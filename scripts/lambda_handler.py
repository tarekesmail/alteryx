import json
import boto3
from kafka import KafkaConsumer, TopicPartition
from kafka.errors import KafkaError
import time
import os
import datetime
import requests
import math

# Get secrets from AWS Secrets Manager
def get_secret(secret_name):
    client = boto3.client('secretsmanager')
    try:
        get_secret_value_response = client.get_secret_value(SecretId=secret_name)
        secret = get_secret_value_response['SecretString']
        return json.loads(secret)
    except Exception as e:
        print(f"Error retrieving secret {secret_name}: {e}")
        return None

# Get consumer lag from Kafka topic
def get_consumer_lag(broker, group, topic, username, password):
    try:
        print(f"Creating Kafka consumer for broker {broker}, group {group}, topic {topic}...")
        consumer = KafkaConsumer(
            bootstrap_servers=broker,
            security_protocol='SASL_SSL',
            sasl_mechanism='PLAIN',
            sasl_plain_username=username,
            sasl_plain_password=password,
            group_id=group,
            auto_offset_reset='earliest',
            enable_auto_commit=False,
            consumer_timeout_ms=5000,
            request_timeout_ms=6000,
            session_timeout_ms=5000
        )

        partitions = consumer.partitions_for_topic(topic)
        print(f"Detected partitions: {partitions}")
        if partitions is None:
            raise KafkaError(f"Topic {topic} not found")

        topic_partitions = [TopicPartition(topic, p) for p in partitions]
        consumer.assign(topic_partitions)

        committed_offsets = {tp: consumer.committed(tp) for tp in topic_partitions}
        end_offsets = consumer.end_offsets(topic_partitions)
        beginning_offsets = consumer.beginning_offsets(topic_partitions)

        total_lag = 0
        for tp in topic_partitions:
            committed_offset = committed_offsets[tp]
            end_offset = end_offsets[tp]
            position = None

            if end_offset == 0 and committed_offset is None:
                lag = 0
            elif end_offset != 0 and committed_offset is not None:
                lag = end_offset - committed_offset
                print(f"lag: {lag}")
            elif end_offset != 0 and committed_offset is None:
                try:
                    beginning = beginning_offsets.get(tp)
                    position = consumer.position(tp,timeout_ms=2000)
                    if position is not None:
                        lag = end_offset - position
                    elif position is None and beginning == 0 and end_offset == 1:
                        lag = 1
                    else:
                        lag = 0
                except Exception as e:
                    print(f"Could not get position for {tp}: {e}")
                    lag = 0
                print(f"lag: {lag}")
            else:
                lag = 0

            total_lag += max(lag, 0)

        print(f"Total consumer lag for topic {topic}: {total_lag}")
        return total_lag

    except KafkaError as e:
        print(f"Kafka error: {e}")
        return None

    finally:
        consumer.close()
        print("Kafka consumer closed.")

# Get the number of running containers with logging and timeout
def get_running_containers_count(instance_ip):
    try:
        # print(f"Fetching container metrics from {instance_ip}...")
        url = f"http://{instance_ip}:2024/container_metrics"
        response = requests.get(url, timeout=5)  
        if response.status_code == 200:
            # print(f"Container metrics retrieved from {instance_ip}.")
            return int(response.text.strip())
        else:
            print(f"Failed to retrieve container metrics from {url}: {response.status_code}")
            return 0
    except Exception as e:
        print(f"Error retrieving container metrics from {url}: {e}")
        return 0

# get the status of the consumer service
def is_consumer_running(instance_ip):
    try:
        url = f"http://{instance_ip}:2024/check_status"
        response = requests.get(url, timeout=5)  
        if response.status_code == 200:
            
            return True if response.text.strip() == "Running" else False
        else:
            print(f"Failed to retrieve consumer service status from {url}: {response.status_code}")
            return 0
    except Exception as e:
        print(f"Error retrieving consumer service status from {url}: {e}")
        return 0

# Check if there are running containers with logging
def has_running_containers(instance_ip):
    return get_running_containers_count(instance_ip) > 0

# Graceful_termination API with logging and timeout
def call_graceful_termination_api(instance_ip):
    try:
        print(f"Calling graceful termination API on {instance_ip}...")
        url = f"http://{instance_ip}:2024/graceful_termination"
        response = requests.post(url, timeout=5)  
        if response.status_code == 200:
            print(f"Service stopped successfully on instance {instance_ip}.")
            return True
        else:
            print(f"Failed to stop service on instance {instance_ip}. Response: {response.status_code}")
            return False
    except Exception as e:
        print(f"Error stopping service on instance {instance_ip}: {e}")
        return False


def safe_to_remove(private_ip):
    if is_consumer_running(private_ip):
        call_graceful_termination_api(private_ip)
        return False
    else:
        return True


def start_service(instance_ip):
    try:
        print(f"Calling service enablement API on {instance_ip}...")
        url = f"http://{instance_ip}:2024/enable_service"
        response = requests.post(url, timeout=5)  
        if response.status_code == 200:
            print(f"Service started successfully on instance {instance_ip}.")
            return True
        else:
            print(f"Failed to start service on instance {instance_ip}. Response: {response.status_code}")
            return False
    except Exception as e:
        print(f"Error starting service on instance {instance_ip}: {e}")
        return False
    
def daily_instance_startup(warmpool_instances, asg_name):
    client = boto3.client('autoscaling')
    ec2 = boto3.client('ec2')

    stopped_instance = ec2.describe_instances(InstanceIds=[warmpool_instances[0]['InstanceId']])

    last_used = datetime.datetime.now(datetime.timezone.utc) - stopped_instance['Reservations'][0]['Instances'][0]['LaunchTime']
    time_diff = datetime.timedelta(hours=24)

    if last_used >= time_diff:
        client.update_auto_scaling_group(
            AutoScalingGroupName=asg_name,
            DesiredCapacity=1
        )

def initialize_warmpool(warmpool_instances, asg_name):
    client = boto3.client('autoscaling')
    ec2 = boto3.client('ec2')
    start_instances = 0
    for instance in warmpool_instances:
        instance_info = ec2.describe_instances(InstanceIds=[instance['InstanceId']])
        if instance_info['Reservations'][0]['Instances'][0]["UsageOperationUpdateTime"] == instance_info['Reservations'][0]['Instances'][0]['LaunchTime']: start_instances += 1

    if start_instances > 0:
        client.update_auto_scaling_group(
            AutoScalingGroupName=asg_name,
            DesiredCapacity=start_instances
        )

def cleanup_instances(latest_image, stopped_instances):
    ec2 = boto3.client('ec2')

    for instance in stopped_instances:
        describe_instance = ec2.describe_instances(InstanceIds=[instance['InstanceId']])
        ami = describe_instance['Reservations'][0]['Instances'][0]["ImageId"]
        instance_id = describe_instance['Reservations'][0]['Instances'][0]['InstanceId']

        if latest_image != ami:
            print(f"Terminating {instance_id} due to old image.")
            ec2.terminate_instances(InstanceIds=[instance_id])
            stopped_count -= 1


# Main lambda handler function
def lambda_handler(event, context):
    workspace_prefix = os.getenv('WORKSPACE_PREFIX')
    max_capacity = int(os.getenv('MAX_CAPACITY'))
    secret_name = f"{workspace_prefix}-compatibility-mode-appsettings"
    warm_pool_size = math.floor(max_capacity * 0.25)

    print("Retrieving Kafka parameters from AWS Secrets Manager...")
    secret = get_secret(secret_name)

    if not secret:
        return {
            'statusCode': 500,
            'body': json.dumps('Error retrieving secret')
        }

    broker = secret['BootstrapServers'].replace("SASL_SSL://", "")
    username = secret['SaslUsername']
    password = secret['SaslPassword']
    customize_enabled = secret['EnableCloudExecutionCustomDrivers']
    concurrent_runs = int(secret.get('ConcurrentRuns', 3))  # Default to 3 if not present

    workspace_id = secret.get('WorkspaceId')
    cluster_name = secret.get('ClusterName')
    group = f"cloudexecutiongroup-{workspace_id}"
    topic = f"{cluster_name}-cloudexecution-{workspace_id}-jobqueue"
    render_topic = f"{cluster_name}-cloudexecution-{workspace_id}-renderqueue"

    # Fetch consumer lag information
    print("Fetching consumer lag information...")
    total_lag = get_consumer_lag(broker, group, topic, username, password)
    total_lag += get_consumer_lag(broker, group, render_topic, username, password)

    if total_lag is None:
        return {
            'statusCode': 500,
            'body': json.dumps('Error fetching consumer lag information')
        }

    # Get the ASG name
    asg_name = f"{workspace_prefix}-compatibility-mode"

    client = boto3.client('autoscaling')
    ec2 = boto3.client('ec2')

    print(f"Fetching Auto Scaling Group: {asg_name}...")
    AutoScalingGroups = client.describe_auto_scaling_groups(AutoScalingGroupNames=[asg_name])
    instance_template = AutoScalingGroups['AutoScalingGroups'][0]['LaunchTemplate']['LaunchTemplateId']
    instance_template_version = AutoScalingGroups['AutoScalingGroups'][0]['LaunchTemplate']['Version']
    
    response = ec2.describe_launch_template_versions(
        LaunchTemplateId=instance_template,
        Versions=[instance_template_version]
    )
    latest_image = response['LaunchTemplateVersions'][0]['LaunchTemplateData']['ImageId']

    total_running_containers = 0

    # Get total number of instances associated with this ASG (includes InService instances)
    asg = AutoScalingGroups['AutoScalingGroups'][0]['Instances']
    asg_size = len(asg)

    response = client.describe_warm_pool(
        AutoScalingGroupName=asg_name
    )

    warmpool_instances = response['Instances'] #ec2.describe_instances(InstanceIds=[response['Instances'][0]['InstanceId']])

    # NOte: warmpool instances aren't counted as part of the asg

    daily_instance_startup(warmpool_instances, asg_name)
    initialize_warmpool(warmpool_instances, asg_name)

    # TODO: We need to see if the instances in the warmpool are refreshed via image change
    cleanup_instances(latest_image, warmpool_instances)

    # AWS native warm pool is managed by ASG, no need to track custom warmpool tags
    total_running = asg

    in_service_instances = []

    for instance in total_running:
        instance_id = instance['InstanceId']
        lifecycle_state = instance.get('LifecycleState', [])

        instance_state = ec2.describe_instance_status(InstanceIds=[instance_id])
        instance_details = ec2.describe_instances(InstanceIds=[instance_id])

        reachability = ''
        instance_statuses = instance_state.get('InstanceStatuses', [])
        reachability = instance_statuses[0]['InstanceStatus']['Details'][0]['Status'] if instance_statuses else "Initializing"


        # Need to set protection for new instances in the asg:
        if reachability == 'passed':
            print(f"Instance {instance_id} is Running. Fetching details...")
            private_ip = instance_details['Reservations'][0]['Instances'][0]['PrivateIpAddress']
            launch_time = instance_details['Reservations'][0]['Instances'][0]['LaunchTime']
            current_time = datetime.datetime.now(datetime.timezone.utc)

            # Protect the instance for 10 minutes after launch
            protection_time = launch_time + datetime.timedelta(minutes=10)
            
            if customize_enabled == "true":
                protection_time = launch_time + datetime.timedelta(minutes=20)

            old_instance = False 
            for tag in instance_details['Reservations'][0]['Instances'][0]['Tags']:
                if tag.get('Key') == 'cefd_setup': old_instance = True

            # TODO: figure out how to have it on for 1 minute if it was stopped before
            # GCP has a variable for that wonder if aws does
            # elif not in_asg:
            #     protection_time = launch_time + datetime.timedelta(minutes=1)

            if not old_instance:
                if current_time < protection_time:
                    print(f"Instance {instance_id} is within protection time.")
                    client.set_instance_protection(
                        InstanceIds=[instance_id],
                        AutoScalingGroupName=asg_name,
                        ProtectedFromScaleIn=True
                    )
                
            # Fetch container count
            container_count = get_running_containers_count(private_ip)
            total_running_containers += container_count
            print(f"Instance {instance_id} has {container_count} running containers.")

            # Protect instance with running containers
            if container_count > 0:
                print(f"Adding scale-in protection to instance {instance_id} due to running containers.")
                client.set_instance_protection(
                    InstanceIds=[instance_id],
                    AutoScalingGroupName=asg_name,
                    ProtectedFromScaleIn=True
                )
            in_service_instances.append(instance)
        elif reachability == 'failed':
            print(f"Instance {instance_id} is in {reachability} state, terminating instance.")
            ec2.terminate_instances(InstanceIds=[instance_id])
        else:
            print(f"Instance {instance_id} is in {reachability} state, treated as 0 running containers.")
            # We have to add protection even if it 
            if lifecycle_state == 'InService':
                client.set_instance_protection(
                        InstanceIds=[instance_id],
                        AutoScalingGroupName=asg_name,
                        ProtectedFromScaleIn=True
                    )
    
    effective_lag = total_lag + total_running_containers
    print(f"Effective Lag (Total Lag + Running Containers): {effective_lag}")

    # Calculate desired capacity based on effective lag
    # AWS native warm pool will automatically handle instance lifecycle
    if effective_lag == 0:
        desired_capacity = 0
    else:
        for i in range(1, max_capacity + 1):
            if (i - 1) * concurrent_runs < effective_lag <= i * concurrent_runs:
                desired_capacity = i
                break
        else:
            desired_capacity = max_capacity
    
    print(f"Desired Capacity: {desired_capacity}")

    if desired_capacity != asg_size:
        client.update_auto_scaling_group(
            AutoScalingGroupName=asg_name,
            DesiredCapacity=desired_capacity
        )
        print(f"Updated {asg_name} to desired capacity {desired_capacity}")
    
    print(f"in service number {len(in_service_instances)}, new capacity {desired_capacity}")

    # Check if services need to be started on instances when there's lag
    # AWS native warm pool will handle scale-in automatically
    for instance in in_service_instances:
        instance_id = instance['InstanceId']
        instance_details = ec2.describe_instances(InstanceIds=[instance_id])

        # For the ip address
        if instance_details['Reservations'][0]['Instances'][0].get('PrivateIpAddress') == None:
            print(f"{instance_id} does not have private ip address so skipping.")
            continue

        private_ip = instance_details['Reservations'][0]['Instances'][0]['PrivateIpAddress']

        instance_state = ec2.describe_instance_status(InstanceIds=[instance_id])

        reachability = ''
        instance_statuses = instance_state.get('InstanceStatuses', [])
        reachability = instance_statuses[0]['InstanceStatus']['Details'][0]['Status'] if instance_statuses else "Initializing"

        # Need to account for instances that are being initialized but we do want to include them in the number of running instances
        if reachability == 'passed':
            launch_time = instance_details['Reservations'][0]['Instances'][0]['LaunchTime']
            creation_time = instance_details['Reservations'][0]['Instances'][0]['UsageOperationUpdateTime']
            current_time = datetime.datetime.now(datetime.timezone.utc)
            protection_time = launch_time + datetime.timedelta(minutes=10)

            # UsageOperationUpdateTime is when it was created
            # LaunchTime is the most recent update
            # the above are the same when its a new instance
            # warmpool instances have these values as the same.

            # This isn't going to work cause this is always going to be true cause all warmpool instances have to be started first in order to get them setup
            # We need a tag to be placed and we search via that.
            # Tags=[{'Key':'cefd_setup', 'Value':'true'}]
            old_instance = False 
            for tag in instance_details['Reservations'][0]['Instances'][0]['Tags']:
                if tag.get('Key') == 'cefd_setup': old_instance = True

            if customize_enabled == "true" and not old_instance:
                protection_time = launch_time + datetime.timedelta(minutes=20)
            elif old_instance:
                protection_time = launch_time + datetime.timedelta(minutes=1)

            print(f"Instance {instance_id} - Launch Time: {launch_time}, Current Time: {current_time}, Protection Time: {protection_time}")
            has_containers = has_running_containers(private_ip)
            can_remove = (total_lag == 0 and current_time >= protection_time and not has_containers)

            if has_containers:
                print(f"Instance {instance_id} running containers, skipping termination.")
            elif can_remove:
                # if stopped_count >= warm_pool_size:
                #     if safe_to_remove(private_ip):
                #         client.terminate_instance_in_auto_scaling_group(
                #             InstanceId=instance_id,
                #             ShouldDecrementDesiredCapacity=True
                #         )
                # else:
                if safe_to_remove(private_ip):
                    client.set_instance_protection(
                        InstanceIds=[instance_id],
                        AutoScalingGroupName=asg_name,
                        ProtectedFromScaleIn=False
                    )
                    ec2.create_tags(
                        Resources=[instance_id], 
                        Tags=[{'Key':'cefd_setup', 'Value':'true'}]
                    )

            elif total_lag > 0 and not is_consumer_running(private_ip):
                print(f"Starting service on {private_ip} due to lag and no running consumer.")
                start_service(private_ip)

        # Start service if there's lag and consumer is not running
        if total_lag > 0 and not is_consumer_running(private_ip):
            print(f"Starting service on {private_ip} due to lag and no running consumer.")
            start_service(private_ip)

    return {
        'statusCode': 200,
        'body': json.dumps({'Effective Lag': effective_lag, 'Desired Capacity': desired_capacity})
    }

if __name__ == "__main__":
    lambda_handler(None,None)