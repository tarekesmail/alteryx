# Changelog

All notable changes to this project will be documented in this file.

## [1.1.2] - 2025-08-19

-  Turning instances in warmpool off after a minute if there is no lag or anything.

## [1.1.1] - 2025-08-15

-  Termianting instances using old ami

## [1.1.0] - 2025-08-14

-  Termianting instances in a failed state
-  Starting one instance in the pool if they haven't been on in 24 hours to help with issue of kafka group being terminated due to inactivity.

## [1.0.22] - 2025-07-09

-  Refining the code

## [1.0.21] - 2025-06-30

-  Adding new api call to start the consumer service when we need runners

## [1.0.20] - 2025-06-21

-  Handle lag scenario when postion and comitted is None 

## [1.0.19] - 2025-06-20

-  Position timeout

## [1.0.18] - 2025-06-20

-  Reduced Session Timed out

## [1.0.17] - 2025-06-20

-  revert lag work

## [1.0.16] - 2025-06-20

### Total Lag Max count fix

## [1.0.15] - 2025-06-20

### Updated

- Fixing partition issue

## [1.0.14] - 2025-06-18

### Updated

- Using positions to overcome an issue when commit offset is None.

## [1.0.13] - 2025-05-22

### Updated

- Fixing issue with undefined commit offset in renderqueue Kafka topic.

## [1.0.12] - 2025-05-05

### Updated

- Adding logic for custom drivers and connectors wait time.

## [1.0.11] - 2025-04-16

### Updated

- Ensuring are fixing issue with excess stopped instances

## [1.0.10] - 2025-04-16

### Updated

- Ensure we are waiting a minute before terminating / instances

## [1.0.9] - 2025-04-16

### Updated

- Modifying changes to fix kafka

## [1.0.8] - 2025-04-08

### Updated

- Adjusting time differences

## [1.0.7] - 2025-04-07

### Updated

- Adding floor

## [1.0.6] - 2025-02-20

### Updated

- Implementing logic to mimic warm pools

## [1.0.5] - 2024-11-04

### Updated

- Reducing protection time to 15 mins after the instance launching.

## [1.0.4] - 2024-10-21

### Updated

- Adding 5-sec timeouts for Kafka consumer and API calls.

## [1.0.3] - 2024-10-16

### Updated

- Implementing new scanning job to ensure no issues with lambda script using bandit.

## [1.0.2] - 2024-10-16

### Updated

- Replaced function name, S3 bucket, and removed the default value for the WORKSPACE_PREFIX env var.

## [1.0.1] - 2024-10-11

### Updated

- Using workspace prefix to get ASG name and secret.

## [1.0.0] - 2024-10-09

### Updated

- Initial version of AWS ASG Lambda function.