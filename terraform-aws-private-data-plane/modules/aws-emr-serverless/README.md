# aws-emr-serverless

#### https://alteryx.atlassian.net/wiki/spaces/AUR/pages/1587546018/EMR+Serverless+Infrastructure+requirements

> Initial implementation

## EMR Serverless: Infrastructure requirements (https://alteryx.atlassian.net/wiki/spaces/AUR/pages/1587546018/EMR+Serverless+Infrastructure+requirements?pageVersion=7)

This documents details infrastructure components that will need to be provisioned to support EMR Serverless jobs in both shared and private data planes.


### Infrastructure components

1. ### S3 Bucket
   
We require an S3 bucket for storing logs and staged temporary files. This more or less the same logging bucket we are already provisioning for EMR on EC2 (https://git.alteryx.com/futurama/bender/aws/tf-modules/aws-emr/-/blob/master/s3.tf). For SDP, we can just repurpose this existing bucket instead of creating a new one.

2. #### IAM Role for launching EMR Serverless applications and jobs

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "EMRServerlessAccess",
            "Effect": "Allow",
            "Action": [
                "emr-serverless:CreateApplication",
                "emr-serverless:UpdateApplication",
                "emr-serverless:DeleteApplication",
                "emr-serverless:ListApplications",
                "emr-serverless:GetApplication",
                "emr-serverless:StartApplication",
                "emr-serverless:StopApplication",
                "emr-serverless:StartJobRun",
                "emr-serverless:CancelJobRun",
                "emr-serverless:ListJobRuns",
                "emr-serverless:GetJobRun"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowNetworkInterfaceCreationViaEMRServerless",
            "Effect": "Allow",
            "Action": "ec2:CreateNetworkInterface",
            "Resource": [
                "arn:aws:ec2:*:*:network-interface/*",
                "arn:aws:ec2:*:*:security-group/*",
                "arn:aws:ec2:*:*:subnet/*"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:CalledViaLast": "ops.emr-serverless.amazonaws.com"
                }
            }
        },
        {
            "Sid":"AllowEMRServerlessServiceLinkedRoleCreation",
            "Effect":"Allow",
            "Action":"iam:CreateServiceLinkedRole",
            "Resource":"arn:aws:iam::<AWS_ACCOUNT_ID>:role/aws-service-role/ops.emr-serverless.amazonaws.com/AWSServiceRoleForAmazonEMRServerless"
        },
        {
            "Sid": "AllowPassingRuntimeRole",
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "<ARN_OF_JOB_RUNTIME_ROLE_CREATED_IN (3)",
            "Condition": {
                "StringLike": {
                    "iam:PassedToService": "emr-serverless.amazonaws.com"
                }
            }
        },
        {
            "Sid": "S3ResourceBucketAccess",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::<S3_BUCKET_NAME_CREATED_ABOVE_FOR_LOGS>",
                "arn:aws:s3:::<S3_BUCKET_NAME_CREATED_ABOVE_FOR_LOGS>/*"
            ]
        },
        {
            "Sid": "KMSAccess",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:Encrypt"
            ],
            "Resource": "arn:aws:kms:*:*:key/*"
        }
    ]
}
```

##### For Shared data plane:

For SDP, this does not need to be a new role. We can just add these permissions to the existing SDP system  IAM role (https://us-east-1.console.aws.amazon.com/iamv2/home?region=us-east-1#/roles/details/role_trusted_user?section=permissions) if they don’t already exist.



#### For Private data plane:

This role should be cross-account and created in the customer’s AWS account.

We will need a trust relationship between the customer’s AWS account and the Alteryx SDP AWS account.

While provisioning, we will also need an external Id associated with this trust relationship. This Id should be unique per customer (Can be based on a customer Id or randomly generated).

The System IAM role  IAM User account (trusted_user-*) in  the SDP should be able to assume this cross-account role via STS.


3. #### IAM Role for EMR Serverless spark job execution
   This is the runtime role that will be used internally by the EMR Serverless Spark job to access AWS resources like S3 or STS.

```
 {
    "Version": "2012-10-17",
    "Statement": [       
        {
            "Sid": "S3ResourceBucketAccess",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::<S3_BUCKET_NAME_CREATED_ABOVE_FOR_LOGS>",
                "arn:aws:s3:::<S3_BUCKET_NAME_CREATED_ABOVE_FOR_LOGS>/*"
            ]
        },
        {
            "Sid": "KMSAccess",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:Encrypt"
            ],
            "Resource": "arn:aws:kms:*:*:key/*"
        },
         {
            "Sid": "STSAccessForAssumingCustomerXAccountRoles",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "*"
        },
        {
            "Sid": "TrifactaPublicBucketAccess",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket",
            ],
            "Resource": [
                "arn:aws:s3:::trifacta-public-datasets/*",
                "arn:aws:s3:::trifacta-public-datasets",
                "arn:aws:s3:::3fac-data-public/*",
                "arn:aws:s3:::3fac-data-public"
            ]
        },
        {
            "Sid": "ListAllBuckets",
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets"
            ],
            "Resource": "*"
        },
    ]
  }
```


We also need a trust relationship that allows the EMR Serverless Service principal to assume this role.

```
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "emr-serverless.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  } 
```

> NOTE: This should be a new role created for both Shared and private planes. For private plane, this does NOT need to be cross-account.


4. ### Networking configuration

We require

Two private subnets in two different AZs (For high availability)

We can reuse what we are already creating for EMR on EC2

#### A VPC endpoint attached to these subnets allowing secure S3 access for buckets in the same region as the Data plane

We can reuse what we are already creating for EMR on EC2 (https://git.alteryx.com/futurama/bender/aws/tf-modules/aws-emr/-/blob/master/emr.tf#L53)

A means for the private subnets to access the internet to support cross-region S3 access in Spark jobs.

We would usually rely on a NAT Gateway for this but looks like current networking configuration we have in place in the SDP (via Transit gateways etc.) allows internet access so no additional work is required there..

#### A security group

A security group that allows all inbound and outbound traffic. (Can be tightened later based on testing.  The fact that we run EMR serverless jobs in private subnets should be enough to meet our security requirements.)


#### Control plane configuration


The following metadata is required to be pushed as a message from the infrastructure side for the control plane to be able to configure itself to talk to the data plane.


```
{
"resourceBucket": "<ID of S3 bucket created from (1)>",
"subnetIds": [<ARRAY OR PRIVATE SUBNET IDs from (4)>],
"securityGroups": [<ARRAY OF SECURITY GROUP IDs from (4)>],
"region": "<AWS REGION OF THE DATA PLANE>",
"jobRuntimeRoleArn": <ARN of role created in (3)>
"jobLaunchArn": "<ARN of role created in (2). PDP Only>",
"externalId": "<External Id for cross-account role above. PDP Only>"
}
```
