# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.6] - 2024-01-29
- Add cluster_additional_security_group_ids to accomodate starayx client
- Remove eks_security_group_id as it has been replaced

## [0.1.5] - 2023-04-25
- Remove traces of Account Alias

## [0.1.4] - 2023-04-24
- Fix S3 acl issue with new AWS security updates
- REF: https://github.com/hashicorp/terraform-provider-aws/issues/28353
- REF: https://docs.aws.amazon.com/AmazonS3/latest/userguide/about-object-ownership.html

## [0.1.3] - 2023-03-01
- adds configuration for subnets tags
- config for aws-auth config map

## [0.1.1] - 2023-02-27

- Add optional variable aws_auth_users to manage aws_auth

## [0.1.0] - 2023-02-06

- Fork from generic module
- Added optional variables with tags for the subnets

## [0.0.11] - 2023-02-03

- fix 0.0.10

## [0.0.10] - 2023-02-03

- fix 0.0.9

## [0.0.9] - 2023-02-03

- use cluster_security_group_id instead of cluster_additional_security_group_ids as is bOrken

## [0.0.8] - 2023-02-03

- allow update on eks default security group

## [0.0.7] - 2023-01-06

- update eks nodegroup policy

## [0.0.6] - 2023-01-06

- update eks autoscaler role

## [0.0.5] - 2023-01-06

- update provider for eks autoscaler

## [0.0.4] - 2023-01-06

- Add eks autoscaler

## [0.0.3] - 2023-01-05

- Pipeline changes for version check

## [0.0.2] - 2022-12-29

- add defaults to var.eks_config

## [0.0.1] - 2022-12-29

- Initial commit to support Versioning
