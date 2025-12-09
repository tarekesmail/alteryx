# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [5.1.0](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v5.0.2...v5.1.0) (2025-12-08)

### Features

* including region into the cmd to verify that the cmd is working as we expect ([6c798f7](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/6c798f70b2d59df1e2d76cfdb9b333cb14eeaee7))

## [5.0.3] (2025-12-08)

### Bug Fixes

* [TCUD-6060] AWS instances in SDP aren't being terminated when cefd is set to false.

## [5.0.2](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v5.0.1...v5.0.2) (2025-12-05)

### Bug Fixes

* update enable_bpm condition ([146e8c5](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/146e8c56ccde84058a10ba673ad65f03475a750e))

## [5.0.1](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v5.0.0...v5.0.1) (2025-12-03)

### Bug Fixes

* [TCIA-6378] Fix bad index for teleport_new asg.tf and redeploy ([c2bf687](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/c2bf687231ef210c3a284390502eb38dcac1ce53))
* update comment for instance_type selection in aws_launch_template ([811d115](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/811d1150e059ab8998b8bb5002027b7ee19ec252))

## [5.0.0](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.12.2...v5.0.0) (2025-12-02)

### ⚠ BREAKING CHANGES

* remove service-specific node groups

### Features

* remove service-specific node groups ([d51e874](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/d51e874a98b67aa53b9daa5151b1e0610bf13f1a))

## [4.12.2](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.12.1...v4.12.2) (2025-12-02)

### Bug Fixes

* refactor instance type assignment in launch template for clarity ([f32de81](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/f32de8141ac43b87dede6661c266d8af5296e3c8))
* update instance type selection logic and expand instance types per region ([bf202fe](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/bf202fe464bd2fb265822d8992de2965257d03f1))

## [4.12.1](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.12.0...v4.12.1) (2025-12-01)

### Bug Fixes

* [TCIA-5983] enable ap-east-1 and me-south-1 regions for CEFDSDP accounts ([c580d28](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/c580d28f78d1643b15caf08fe89a02350e0b2123))

## [4.12.0](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.11.0...v4.12.0) (2025-12-01)

### Features

* moving describeimages out to its own permission as it shouldn't cause any security problems ([33abc4a](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/33abc4aa12af44dafd735b3f9c50f2a7e6529fa7))

## [4.11.1] (2025-11-26)

### Bug Fixes

* [TCUD-6078] IAM permission being denied for describeimages

## [4.11.0](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.10.1...v4.11.0) (2025-11-25)

### Features

* **kafka:** [TCIA-6386] create bpm-kafka-secret-json in cefdshared ([01ad8ec](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/01ad8ec580469bb397b75c8fc799b6333d2ae048))

## [4.10.1](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.10.0...v4.10.1) (2025-11-24)

### Bug Fixes

* [TCIA-6334] update Bridge Private Link role name to remove prefix variable ([4528ba1](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/4528ba17704df37d5a160303e02b58c248459a27))

## [4.10.0](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.9.2...v4.10.0) (2025-11-24)

### Features

* **IAM:** [TCIA-6334] add Bridge Private Link IAM role and policy creation ([23e2325](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/23e23252ec4af5dc4a755d8dabbaddcc08857ebe))

## [4.9.2](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.9.1...v4.9.2) (2025-11-18)

### Performance Improvements

* TCIA-6215 add multi-tag support for MAJOR/MINOR version references ([1b128a8](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/1b128a86e0411225e17ee586d6dfb9e7c5b7d7a4))

## [4.9.1](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.9.0...v4.9.1) (2025-11-13)


### Performance Improvements

* [TCIA-6348] update upwind int module version ([7ab4243](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/7ab4243fb29506174f657b1804af54fa332826c3))

# [4.9.0](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.8.4...v4.9.0) (2025-11-10)


### Features

* **lambda:** add read permission for datadog api key to cefd lambda ([3a80307](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/3a803073d05cdcfb6133be5db18a5b1cf64ea3a6))

## [4.8.5](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.8.4...v4.8.5) (2025-11-10)

### Features

* [TCUD-6005] Grantig read access for Datadog API key to CEFD Lambda

## [4.8.4](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.8.3...v4.8.4) (2025-11-07)


### Bug Fixes

* **memorydb:** update count condition for coredns and bpm sg rule ([721ecfd](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/721ecfd79e63a82d4518f6330e31d80959eb24f7))

## [4.8.3](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.8.2...v4.8.3) (2025-11-06)


### Bug Fixes

* teleport registration issue for coredns ([829c76c](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/829c76cb2996275224ee341efeed33ba54c4f0e7))

## [4.8.2](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.8.1...v4.8.2) (2025-11-05)


### Bug Fixes

* [TCIA-6280] add preserve argument to eks addon ([0a67647](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/0a676474b9f946acabdb95bcfecca777198b6842))

## [4.8.1](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.8.0...v4.8.1) (2025-11-03)


### Bug Fixes

* **scotty:** use WI creds in scotty script ([6d9d9e2](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/6d9d9e2f5348c4e290aef7c83cb53af717e46634))

# [4.8.0](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.7.2...v4.8.0) (2025-11-03)


### Features

* **node groups:** do not provision service specific node groups in lowers ([0d03358](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/0d0335853ad240f71ae47471dc84c55634503af8))

## [4.7.2](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.7.1...v4.7.2) (2025-10-31)


### Bug Fixes

* deploy bridge proxy manager resources in cefdshared ([e826867](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/e826867c90dbbb1b827bf0210f58f784d37f5e3e))

## [4.7.1](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.7.0...v4.7.1) (2025-10-30)


### Bug Fixes

* **bpm:** enable bpm for non-pdp data planes ([13c5299](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/13c529960110f229b36c091ded511c9df5ef2064))

# [4.7.0](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.6.2...v4.7.0) (2025-10-20)


### Features

* [TCIA-5984] update data plane account and whitepaper to support cefdshared data plane ([864a87e](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/864a87e517a8917a71f384849326082534d04039))

## [4.6.2](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.6.1...v4.6.2) (2025-10-20)


### Bug Fixes

* [TCIA-5797] fixing 4.5.26 ([d501752](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/d501752684f990b757b1915c40afca420f3edbd7))

## [4.6.1](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.6.0...v4.6.1) (2025-10-15)


### Bug Fixes

* [TCIA-5986] add variables and locals in root and compatility_mode module... ([6dfd3ae](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/6dfd3ae274075a993f98428f31678a1e367a195b))

# [4.6.0](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/compare/v4.5.26...v4.6.0) (2025-10-09)


### Features

* [TCIA-6131] enable automated releases with semantic-release ([f9caf90](https://git.alteryx.com/futurama/bender/tfcloud-modules/terraform-aws-private-data-plane/commit/f9caf9061d6778a7078165e54dffd8ecebb89c99))

## [4.5.26] - 2025-10-07

- [TCIA-5797] cluster-autoscaler policy rename following the naming convention
- juicefs-s3 policy restrict s3 actions 
- secrets-manager-access policy rename following the naming convention
- bridge-proxy-manager iam policy remove not required actions
- remove coredns-role role. Role contains only secret-manager-access policy which is not required.
- container-service-access policy rename following the naming convention
- compatibility-mode secrets-manager-accesspolicy rename following the naming convention restrict policy
- starayx secrets-manager-access simplify policy statement
- AmazonEKS_EBS_CSI_Policy policy rename following the naming convention

## [4.5.25] - 2025-09-23

- [TCIA-5379] Adds an S3 bucket policy (aws_s3_bucket_policy.emr_logs) to the EMR Serverless module

## [4.5.24] - 2025-10-01

- [TCUD-5654] Terminate detached zombie instances from ASG

## [4.5.23] - 2025-09-19

- [TCIA-6053] Update cluster_autoscaler policy actions to match best practice

## [4.5.22] - 2025-09-25

- [TCIA-5825] Removed deprecated upwind configuration due to them not being applicable or utilized anymore.
- Upwind integration is no longer used but configurations remain for resource cleanup
- Mark Upwind configurations as deprecated for cleanup purposes

## [4.5.21] - 2025-09-24

- [TCUD-5696] Fixing minor error

## [4.5.20] - 2025-09-23

- [TCUD-5696] Updating workertimeout depending on the dataplane type and not having data get created if in a shared dataplane.

## [4.5.19] - 2025-09-17

- [TCUD-5851] Updating references and cases

## [4.5.18] - 2025-09-17

- [TCUD-5851] Removes IAM Container Role for SDP

## [4.5.17] - 2025-09-17

- [TCUD-5851] Restrict SecretsManager permissions for CEFD IAM Role

## [4.5.16] - 2025-09-12

- [TCIA-4933] Fixing slight bug introduced into the upwind log reporter module in v4.5.13
  - Reverting the change in v4.5.13 - switched `local.pdp_eks_name` to `module.eks_blue.cluster_name` to reference dependency explicitly
  - This value is used in a for_each in the upwind module and so it must be known during plan which is why the local value was used in the first place

## [4.5.15] - 2025-09-10

- [TCIA-6031] Update condition to enable coredns so it is the same as the condition to enable bridge proxy manager
  - CoreDNS is still in testing and should be toggleable option instead of being enabled by default

## [4.5.14] - 2025-09-09

- [TCIA-5378] Adds juicefs bucket policy.

## [4.5.13] - 2025-09-05

- [TCIA-4933] AWS PDP code refinement
- The incredibly verbose option condition checks that are used to enable features can be grouped into one of two categories: options that create a k8s cluster and all options. Adding two locals: one to check if an option that creates a k8s cluster is enabled and another to check if any option is enabled. This can be used in place of copy/pasting the long OR conditional and will make it easier to modify options or create additional logical groupings in the future.
- Switched the `isNotPDP` local to `is_pdp` and used the `!` operator to inverse the result. This now matches terraform naming conventions (snake case) and makes it so the true condition matches the name avoiding a double negative (true = pdp, false = not pdp).
- Updated the teleport, starayx, and upwind modules to reference the eks cluster name via output from the eks module to naturally build the dependency mapping instead of using an explicit depends_on block.
- Clean up redundant conditional statements. There are many conditionals that evaluate a boolean value to a value of either true or false. This is unnecessary in situations where we need the conditional to evaluate to true/false.
- [Qodo] Added description to all outputs and left some TODO comments in the code.

## [4.5.12] - 2025-09-04

- [TPROD-2357] Switching to a custom launch template when enabling IMDSv2 disabled the 'disk_size' arg for eks managed node pools.
- Adding in 'block_device_mappings' config that should set the volume size for /dev/xvda to 50 (default) or 500 (common-job).
- Looking at the examples in the EKS module repo, this should increase the ephemeral storage.

## [4.5.11] - 2025-09-01

- [TCIA-5798] Create juicefs-s3 policy following the naming convention

## [4.5.10] - 2025-08-13

- [TCIA-5977] Pin a version for iam-role-for-service-accounts-eks module

## [4.5.9] - 2025-08-06

- [TCIA-5793] Limit credential-service-kms-key-policy policy permissions used in credential-service-role role

## [4.5.8] - 2025-08-05

- [TCIA-5792] Limit argocd-external-secrets role permissions

## [4.5.7] - 2025-08-04

- [TCIA-5719] Set EBS volume to encrypted by default

## [4.5.6] - 2025-08-04

- [TCIA-5912] Remove argocd-gar-access role

## [4.5.5] - 2025-07-17

- [TCIA-5810] Add a firewall rule to allow Cluster API to Cluster nodes on port 8000 for VPA Admission Controller

## [4.5.4] - 2025-07-23

- [TSRE-5157]  Upgrade PDP EKS version from 1.30 to 1.31
  Upgrade AWS EKS addons to match versions used in SDP

## [4.5.3] - 2025-07-16

- Fixing attach policy being removed from IAM role

## [4.5.2] - 2025-07-09

- [TCIA-5731] Create pact-key secret on SDP following the naming convention

## [4.5.1] - 2025-07-02

- [TCIA-5566] Inject Futurama SentinelOne token for coredns, starxyx, bpm for startup

## [4.5.0] - 2025-07-02

- [TCIA-5289] Update hashicorp/google provider pinned version to `5.x`

## [4.4.5] - 2025-07-02

- [TCIA-5692] Modify sa-oauth-token script to create a secret version with a valid UUID. This is required because of k8s ESO UUID validation. More info:<https://github.com/external-secrets/external-secrets/issues/4973>

## [4.4.4] - 2025-07-02

- [TCIA-4898] configured upwind cloudscanner to always be applied
- updated upwind cloud integration module version

## [4.4.3] - 2025-07-01

- [TCIA-4898] configured upwind cloud connection to always be applied

## [4.4.2] - 2025-07-01

- [TCIA-5667] Add upper/lowers security groups

## [4.4.1] - 2025-07-01

- Bump upwind log exporter module to v0.1.1

## [4.4.0] - 2025-06-30

- [TCIA-5599] Add IAM policy for CEfD customization in `pdh-iam` folder
- Have to bump minor version due to IAM changes

## [4.3.0] - 2025-06-26

- [TCIA-5580] Increase ephemeral storage for `common-job` node pool to 500gb
- This change will cause `common-job` node pool to be recreated

## [4.2.9] - 2025-06-26

- [TCIA-5582] Adding launch template to eks_managed_node_group_defaults so we only define it once.

## [4.2.8] - 2025-06-26

- [TCIA-5582] Enabling IMDSV2 for EKS nodes, CEFD and StarAyx VMs.

## [4.2.7] - 2025-06-26

- [TCIA-5417] Removed tf cloud IPs

## [4.2.6] - 2025-06-19

- [TCIA-5608] Create JuiceFS secret following the naming convention.

## [4.2.5] - 2025-06-18

- Updating appsettings file to include max capacity and autoscaling function version.

## [4.2.4] - 2025-06-18

- Remove `configuration_aliases` from the required_providers aws block in dp-account and dp-account-whitepaper as the `css` alias is not used

## [4.2.3] - 20245-06-18

- Add upper version limits for aws, helm, and confluent providers

## [4.2.2] - 2025-06-13

- Adding dataplane type to appsettings

## [4.2.1] - 2025-06-11

- [TCIA-5559] Assign asg_aws-saml-futurama-upper-security and asg_aws-saml-futurama-lower-security IdC groups to DDP accounts

## [4.2.0] - 2025-06-10

**[IMPORTANT]**
Versions 4.1.9 through 4.1.13 are **deprecated due to unresolved bugs** and will be deleted.
**Do NOT use 4.1.9, 4.1.10, 4.1.11, 4.1.12, or 4.1.13.**

This release 4.2.0 is a stable aggregation of all valid and fixed changes since 4.1.8.

### Added

- Consolidated and stabilized all safe changes post-4.1.8.
- Previous critical issues in .9–.13 resolved.

## [4.1.13] - 2025-06-01  ⚠️ **Deprecated – buggy, do not use**

- Adding new redis secret, resolving TCIA-4889

## [4.1.12] - 2025-06-06  ⚠️ **Deprecated – buggy, do not use**

- [TCIA-5581] Adding drata to DDPs, removing it from the root directory.

## [4.1.11] - 2025-06-03  ⚠️ **Deprecated – buggy, do not use**

- [TCIA-5557] Adding ENABLE_DCM_SERVICE variable which is set by the value of EnableDCMService key from IDPS payload.

## [4.1.10] - 2025-05-30  ⚠️ **Deprecated – buggy, do not use**

- [TCIA-4900] Fix count error for upwind cloud connection

## [4.1.9] - 2025-05-26   ⚠️ **Deprecated – buggy, do not use**

- [TCIA-4900] Configured EKS log exporter for upwind.

## [4.1.8] - 2025-05-13

- [TCIA-5122] Add `dptype = "dedicated"` tag to local.tags in `dp-project/dp-account/locals.tf`
- This will add a new tag to the DDP AWS account, which will then be propagated into Orca
- This is a requirement from InfoSec in order to filter DDPs in Orca

## [4.1.7] - 2025-05-15

- [TCIA-4903] Added upwind credentials and integration with upwind cloud

## [4.1.6] - 2025-05-15

- [TCIA-5402] Removing Drata module call from dp-account-whitepaper, this enables drata in every data plane
- Fix of 4.1.5

## [4.1.5] - 2025-05-14

- [TCIA-5402] Deploying drata in all DDPs and PDPs

## [4.1.4] - 2025-05-08

- [TCIA-4969] Add security group rule to allow connectivity from starayx to memorydb when memorydb is enabled

## [4.1.3] - 2025-05-08

- [TCIA-5415] Increase disk space for starayx VM to 30 GB.

## [4.1.2] - 2025-05-07

- Change EnableCloudExecutionCustomDrivers Variable type to String

## [4.1.1] - 2025-05-07

- [TCIA-5415] Increase disk space for starayx VM to 12 GB.

## [4.1.0] - 2025-05-07

- [TCIA-4515] Removing sg_aws-saml-futurama-lower-shared-dp-audit, sg_aws-saml-futurama-lower-shared-dp-security and sg_aws-saml-futurama-lower-shared-dp-admins from dp-account. NOTE: The mentioned groups will be removed from AD, previous version of this module will fail as the groups will not exist in Identity Center.

## [4.0.10] - 2025-05-05

- Added EnableCloudExecutionCustomDrivers in Appsettings secret so we can check if the feature is enabled on VM

## [4.0.9] - 2025-05-04

- Fix deletion error on non empty bucket by adding force_delete for cefd customization bucket

## [4.0.8] - 2025-04-30

- Fix formatting of `enableCloudExecutionCustomization` output

## [4.0.7] - 2025-04-28

- [TCIA-5198] Add variable and output for Cloud Execution Custom Driver
- Create `ENABLE_CLOUD_EXECUTION_CUSTOMDRIVER` variable and `cefd_custom_driver` output that returns the value of the variable
- Renamed variable in CEfD module from `CLOUD_EXECUTIONS_CUSTOMDRIVER_ENABLED` to `ENABLE_CLOUD_EXECUTION_CUSTOMDRIVER` to match name of root level var

## [4.0.6] - 2025-04-25

- [TCIA-5308] Add planeType label to argocd

## [4.0.5] - 2025-04-24

- Fix min and desired capacity for CEFD when Auto Scaling is disabled.

## [4.0.4] - 2025-04-23

- Move `autoscaling_group_tags` into a submodule of the `eks_blue` module
- This resource was causing some cycle errors when enabling Appbuilder or switching between Appbuilder and other options that create a Kubernetes cluster

## [4.0.3] - 2025-04-23

- [TCIA-5318] reverting 4.0.1 because it needs further testing since it creates gp3 volume types by default and we
- currently use gp2 volume types everywhere so on conversion we might have some data loss.

## [4.0.2] - 2025-04-23

- [TCIA-5183] Removing aws sdp provider from drata

## [4.0.1] - 2025-04-22

- [TCIA-5318] Update aws_eks_addon to take in configuration_values if they exists in the eks_config cluster_addons.

## [4.0.0] - 2025-04-18

### ⚠️ Breaking Changes

- [TCIA-5251] - Update DDP VPC CIDRs to avoid conflicts with the Starayx WireGuard allow list.
  This is a Breaking change for DDP's and requires DDP options to be disabled on the existing version to be in place before upgrading to this version.
- Bumped `pdh-networking` module version to `v0.1.4`

## [3.6.27] - 2025-04-16

- [TCIA-5284] Add Pingone Environment ID to credential-transfer-apis-auth-config secret for Credential Mgmt

## [3.6.26] - 2025-04-11

- [TCIA-5330] Update list of node pools enabled with AAI is enabled to remove some extras
- Update name for list of node pools passed to eks module from eks_managed_node_groups to eks_managed_node_groups_filtered to avoid using the same variable name in different modules

## [3.6.25] - 2025-04-08

- Move `EKS_NODE_AMI` and `EKS_VERSION` from `locals.tf` to `eks_defaults.tf`
- Upgrade `EKS_NODE_AMI` to `1.30.9-20250403` to match SDP version

## [3.6.24] - 2025-04-08

- Fixing  'ok' (last state: 'want exactly 1 healthy instance(s) in Auto Scaling Group, have 0', timeout: 10m0s)

## [3.6.23] - 2025-04-07

- [TCUD-5474] Modify IAM role set to cefd instances to allow for self image description
- Modifing -compatibility-mode to allow for instances to describe their images for datadog logging.

## [3.6.22] - 2025-04-07

- Making modification changes for AWS warm pool

## [3.6.21] - 2025-04-04

- [TCIA-4896] Create `ResourceInventoryRole` in accounts created for DDP
- This role allows IT team to automate the invetory of our AWS cloud assets

## [3.6.20] - 2025-04-03

- [TCIA-5183] Add Drata module integration to uppers dedicated data plane

## [3.6.19] - 2025-04-02

- [TSRE-4389] Upgrade PDP EKS version from 1.29 to 1.30
- Upgrade AWS EKS addons to match versions used in SDP

## [3.6.18] - 2025-04-01

- Make JuiceFS optional depending on which applications have been selected

## [3.6.17] - 2025-04-01

- Create New bucket for custom drivers and connectors.

## [3.6.16] - 2025-03-29

- Secrets refactor
- [TCIA-5235] Formatting issue fixes in Kafka secrets and include kafka secrets on CEFD selection
- Avoid creating secrets when products not selected

## [3.6.15] - 2025-03-29

- updating eks module to create `aws_security_group_rule allow_eks_to_memorydb` only if enable_memeorydb is set to true for prod
- TCIA-5236

## [3.6.14] - 2025-03-26

- Enable `common-job` node pool in uppers
- Rename `common-job` to `common-jobs` to force replacement of node group
- This is necessary because Terraform does not manage the `desired_size` value after creation and will throw an error that the new min size of 1 is greater than desired size of 0
- Increase `common-jobs` max size to 100 in Int and Preprod and 75 in all other projects

## [3.6.13] - 2025-03-26

- Increase Starayx VM size from `t3a.micro` to `t3a.medium`
- There were some startup issues due to the VM running out of memory, so it was decided to standardize Staryx VM with 2vCPU and 4GB memory

## [3.6.12] - 2025-03-24

- Removed special characters from the Redis password
- Enabled memory DB creation for CEFD enablement for Bridge Framework, specifically for DDPs
- Updated platform.json in BPM to pass control plane information and dataplane ID
- Updated CoreDNS and BPM enablement only for dedicated dataplanes

## [3.6.11] - 2025-03-21

- Adding aws_iam_role_policy_attachment so TF handles the detachment of the policy on destruction

## [3.6.10] - 2025-03-21

- Remove feature flag `jobExecution.kubernetes.clusterName`

## [3.6.9] - 2025-03-17

- Update BPM SG group rules to allow inbound traffic on all ports

## [3.6.8] - 2025-03-17

- [TCIA-5078] Rename var.ENABLE_PRIVATE_API_ACCESS to var.ENABLE_PRIVATE_K8S_API_ACCESS

## [3.6.7] - 2025-03-13

- Add CoreDNS enable and disable feature
- append the coredns enable to kafka secrets

## [3.6.6] - 2025-03-12

- Enable additional node pools when APPBUILDER is enabled to support dependencies (photon and file)

## [3.6.5] - 2025-03-13

- Enable warmpool/redis only in prepord

## [3.6.4] - 2025-03-13

- Refactor MemoryDB TF code in AWS PDP to support for CEFD
- TCIA-4656

## [3.6.3] - 2025-03-12

- Enable additional node pools when AAI is enabled to support dependencies

## [3.6.2] - 2025-03-11

- Enable starayx for appbuilder

## [3.6.1] - 2025-03-11

- Fix setting of conductor resource toggle to boolean check not string matching

## [3.6.0] - 2025-03-10

- Update missing CEFD IAM policy as per <https://alteryx.atlassian.net/wiki/spaces/CE/pages/2148958250/Cloud+Execution+for+Desktop+CEfD+in+AWS>

## [3.5.18] - 2025-03-04

- Kafka secrets (Resolving TCIA-4906)

## [3.5.17] - 2025-03-06

- use common input variable for all three clouds `ENABLE_PRIVATE_API_ACCESS`

## [3.5.16] - 2025-03-03

- replacing Teleport VM module with images from VMSDLC for ArgoCD to access k8s cluster with PRIVATE ENDPOINT controlled by feature flag: `var.teleport_active_cluster_endpoint`
- option to provision k8s cluster with PRIVATE ENDPOINT controlled by feature flag: `var.teleport_active_cluster_endpoint`

## [3.5.15] - 2025-02-28

- Fix issues between the dependes_on added on 3.5.13 and data source added on 3.5.11 versions

## [3.5.14] - 2025-02-27

- [TCIA-3934] Update ArgoCD cluster registration resourceConductorToggle

## [3.5.13] - 2025-02-27

- TCIA-4658 Adding script to cleanup orphan EBS after EKS deletion
- Add sleep to fix errors when destroying credential services policies

## [3.5.12] - 2025-02-26

- Fix issues around secrets condition evaluations when coredns is disabled

## [3.5.11] - 2025-02-26

- Recreate common node pool as 3 separate node groups, 1 per subnet
- This is to create one ASG per zone to support EBS volumes
- [TCIA-4702](https://alteryx.atlassian.net/browse/TCIA-4702)
- Fix issues around secrets condition evaluations when coredns is disabled

## [3.5.10] - 2025-02-25

- Create new argo-registration variable for OR condition to support labels (deploy appBuilder OR designerCloud)

## [3.5.9] - 2025-02-19

- Update deprecated args used in `aws_iam_role`
- Use `aws_iam_role_policy` resource instead of `inline_policy` argument to define inline policies for roles

## [3.5.8] - 2025-02-18

- CoreDNS configuration details to AWS Secrets Manager for CEFD communication

## [3.5.7] - 2025-02-12

- Removing unused iam account aliases

## [3.5.6] - 2025-02-11

- Fixing issue with CLOUD_EXECUTION_AUTOSCALING_VERSIONS using empty string rather then default.

## [3.5.5] - 2025-02-10

- Removing CLOUD_EXECUTION_LAMBDA_VERSIONS as it was added back in mistakenly.

## [3.5.4] - 2025-02-07

- Update variable inputs for bridge-proxy-manager and fix ami prefix

## [3.5.3] - 2025-02-07

- [TCIA-4814] Removes the sort_ascending from the instances of the data resource aws_ami_ids to accomodate a bug solved on the provider side.  This bug fix in version 5.85.0 of the provider meant that this sort_ascending being true was giving us the oldest AMI available instead of the newest.  It defaults to false.

## [3.5.2] - 2025-01-30

- Adds automatic versioning for CEFD AutoScaling Lambda function

## [3.5.1] - 2024-12-09

- Addition of bridge proxy manager VM & coredns VM
- This includes updates to redis security group ingress in respective modules for communication with redis
- Support for teleport registration
- All resources are behind ENABLE_BRIDGE_PROXY_MANAGER variable

## [3.5.0] - 2024-12-09

- [TCIA-4272](https://alteryx.atlassian.net/browse/TCIA-4272) and [TCIA-4273](https://alteryx.atlassian.net/browse/TCIA-4273)
- Remove Aidin as part of cost optimization initiative because it is no longer offered as a product
- Update source of `secrets_manager` module in memorydb and credential-service module
- Rename Confluent service account and api key resources so name does not contain `aidin`
- Delete `gpu` and `gpu-big-iron` node groups and related resources

## [3.4.20] - 2025-01-22

- Added a dependency between the module.irsa and the secret `${local.resource_name}-job-runner-sa-oauth-token` to ensure the role
- is deleted before the secret, preventing conflicts during resource recreation.
- The goal is to delete the module.irsa before the secret is deleted by terraform.

## [3.4.19] - 2025-01-20

- Adding feature flag `jobExecution.kubernetes.clusterName`

## [3.4.18] - 2025-01-14

- Update `common-job` node pool to use `m6a.4xlarge, m6i.4xlarge, m5.4xlarge, m5a.4xlarge` instances

## [3.4.17] - 2025-01-13

- TCIA-4647 Create values file on global repo with VPC cidr to use in ingress-nginx chart

## [3.4.16] - 2025-01-13

- Enable common-job node pool in uppers if auto insights is enabled

## [3.4.15] - 2025-01-09

- Fixes appbuilder output typo

## [3.4.14] - 2025-01-09

- Enable JuiceFS when AAI is enabled

## [3.4.13] - 2025-01-07

- Add appBuilderToggle to the data-plane-register module variables

## [3.4.12] - 2025-01-08

- Adding default value to DATAPLANE_TYPE variable to be compatible with TFC

## [3.4.11] - 2025-01-07

- Add autoInsightsToggle to the data-plane-register module variables

## [3.4.10] - 2025-01-07

- Update instance types for `common-job` node pool

## [3.4.9] - 2024-12-20

- Update README.md

## [3.4.8] - 2024-12-20

- TCIA-4534 create KMS key for DDP to use in data plane credential service

## [3.4.7] - 2024-12-18

- Define Kubernetes version in PDP module again

## [3.4.6] - 2024-12-17

- Create Auto Insights resource toggle
- Create AppBuilder resource toggle

## [3.4.5] - 2024-12-17

- Removing jsonencoded to local pingone_config_starayx_auth and defining as a map and passing it as a secre-value pair.

## [3.4.4] - 2024-12-16

- Enable Starayx again for all AWS PDP

## [3.4.3] - 2024-12-12

- Fixing local.CHECK_ENVIRONMENT reference.

## [3.4.2] - 2024-12-11

- Enable Starayx for Pre Prod.

## [3.4.1] - 2024-12-11

- Add `dynamoDB:*` and `s3:*` actions to `container_service_access` policy document in CEfD module

## [3.4.0] - 2024-12-10

- The simulator policies aren't on the main HELP page for clients to setup so we don't want to report them as missing and not be in the docs

## [3.3.5] - 2024-12-03

- reducing the heartbeat timeout to 30 seconds, since AWS service linked autoscaling group is able to propagate in few seconds

## [3.3.4] - 2024-12-03

- add initial_lifecycle_hook to cefd asg to allow instance profile changes to propagate to fix autoscaling errors #TCIA-4572

## [3.3.3] - 2024-12-03

- Change common node pool instance type in lowers from `large` to `xlarge` so we are using a 4 core instance

## [3.3.2] - 2024-11-28

- TCIA-4539 add missing region eu-west-3 to memorydb availability zones definition

## [3.3.1] - 2024-11-26

- Use t3a.large and t3.large instances for common node group in lowers instead of 2xlarge

## [3.3.0] - 2024-11-22

- Disabling Starayx module in uppers environment as it is not ready and was causing issues in ACI workspacen and incurring costs for idle resources (secrets, asg)
- Flag can updated/removed once we are ready to use Starayx in production PDPs

## [3.2.5] - 2024-11-20

- Min Size 3 for Common Nodepool

## [3.2.4] - 2024-11-20

- Adding redis_config_secret to platform.json for starayx.

## [3.2.3] - 2024-11-20

- Enable Credential Mgmt infra in uppers

## [3.2.2] - 2024-11-13

- Removing Karpenter Code

## [3.2.1] - 2024-11-13

- Correct instance types for common job node pool

## [3.2.0] - 2024-11-08

- TCIA-4434: Add CEFD Policy Updates, no terraform changes

## [3.1.17] - 2024-11-07

- Disk size for BullMQ Nodepool

## [3.1.16] - 2024-11-07

- Update common job node pool labels
- Scale common job node pool to 0 in lowers
- Do not create common job node pool in uppers

## [3.1.15] - 2024-11-06

- Update name of common job node pool from `common-jobs` to `common-job` to match other PDPs

## [3.1.14] - 2024-11-06

- [TCIA-4180](https://alteryx.atlassian.net/browse/TCIA-4180)
- Create common job node pool so that the other job node pools can be deleted for cost savings

## [3.1.13] - 2024-11-05

- Update lambda version for the regex.

## [3.1.12] - 2024-11-05

- Removing reverse in the STARAYX_AMIS_IMAGES_MAP since the data.aws_ami_ids.starayx already sorts in ascending order.
- With reverse, the oldest AMI was incorrectly assigned to latest instead of the newest AMI, which is the intended behavior.
- Removed reverse for CEfD as well. For the same reasons.

## [3.1.11] - 2024-11-04

- Changing the Lambda's IAM role name and using the latest Lambda version - TCUD-5209

## [3.1.10] - 2024-10-29

- Removing spot nodepool to resolve TCIA-4374
- Renaming nodepool to resolve TCIA-4384
- Fixing nodepool instance types in TCIA-4384

## [3.1.9] - 2024-10-28

- Adding domain_prefix to starayx platform.json.

## [3.1.8] - 2024-10-28

- Preventing ASG errors if CLOUD_EXECUTION_MAX_SCALING value is less than 2.

## [3.1.7] - 2024-10-28

- Move `argo-registration` resources in `data-plane-register` module
- Add shell script to void finalizers for teleport-agent in Argo after cluster secret is deleted
- [TCIA-3985](https://alteryx.atlassian.net/browse/TCIA-3985)

## [3.1.6] - 2024-10-25

- Setting instance count to zero for spot instance pool as availability is not guaranteed

## [3.1.5] - 2024-10-21

- Updating CEFD ASG min, max, and desired values

## [3.1.4] - 2024-10-17

- TCIA-4209-juicefs-s3

## [3.1.3] - 2024-10-15

- prevent conflicting policy SIDs

## [3.1.2] - 2024-10-11

- Removing the EKS Cloudwatch Group

## [3.1.1] - 2024-10-07

- Increasing the number of kafka topics for aws to 20 for job queues.

## [3.1.0] - 2024-10-02

- [TCIA-3557](https://alteryx.atlassian.net/browse/TCIA-3557)
- Move the SimulatePrincipalPolicy policy from AIDiN to Base to we can use it during validation
- The ListEntitiesForPolicy was also bundled alongside, so it was moved as well
- This specific version does not need to be rolled out through the environments, it can tag along with a later update

## [3.0.8] - 2024-10-04

- [TCIA-4048](https://alteryx.atlassian.net/browse/TCIA-4048)
- Remove cefd_enabled bool from Teleport module and do not create if CEfD is enabled

## [3.0.7] - 2024-10-01

- TCIA-4249 - Cleanup of orphaned tcp loadbalancers after PDH destroy

## [3.0.6] - 2024-09-30

- [TCUD-5148](https://alteryx.atlassian.net/browse/TCUD-5148)
- Add CefdLatestImage key-value to appsettings secret

## [3.0.5] - 2024-09-30

- Renamed credentialManagement output

## [3.0.4] - 2024-09-26

- Missing JuiceFS Secret

## [3.0.3] - 2024-09-20

- Add Egress ips to DDP whitepaper module outputs

## [3.0.2] - 2024-09-20

- [TCIA-4048](https://alteryx.atlassian.net/browse/TCIA-4048)
- Remove Teleport from cloud-execution module as it is has been removed from the CEfD image and is no longer required
- Cleanup variables used for Teleport in cloud-execution module

## [3.0.1] - 2024-09-25

- Update Vault type for Credential Mgmt Service

## [3.0.0] - 2024-09-22

- TCIA-3557
  - |
    There are NO terraform changes with this version. We are simply adding
    a "policy" module that represents the AWS Policy JSON that we are using in
    our whitepaper for clients to follow in order to grant access to be able to
    apply this terraform code. If you add code that requires some additional
    AWS permissions, we need to add it to the appropriate JSON file.
  - Adding a CONTRIBUTING.md file
    - Detail the use of the `./modules/pdh-iam` module

## [2.1.6] - 2024-09-24

- Update oidc url for credential mgmt service

## [2.1.5] - 2024-09-19

- Modify ddp account to consume last two blocks of UUID (ex: ddp-xxxx-xxxxxxxxxxxx)

## [2.1.4] - 2024-09-18

- Handle DDP sso configuration to dp account crreation module

## [2.1.3] - 2024-09-10

- update ddp account name to full ulid

## [2.1.2] - 2024-09-09

- Update argocd registration secrets labels

## [2.1.1] - 2024-09-03

-add `force_destroy = true` to juiceFS s3 bucket

## [2.1.0] - 2024-09-03

- Karpenter Fix
- Temporarily forking terraform-aws-eks module v20.24.0

## [2.0.50] - 2024-08-29

- Update timeout for cefd container role to 12 hours

## [2.0.49] - 2024-08-27

- Update SECRETS variable type to string with default ""
- Add account creation modules for DDP/TFAyx (unified codebase)

## [2.0.48] - 2024-08-27

- Separating control plane tags from PDP tags for starayx.
- Setting auth mode to API_AND_CONFIG_MAP.

## [2.0.47] - 2024-08-26

- Karpenter

## [2.0.46] - 2024-08-22

- fixes

## [2.0.45] - 2024-08-20

- Updated pingone secret name.

## [2.0.46] - 2024-08-20

- REMOVED - Do not use

## [2.0.45] - 2024-08-20a

- REMOVED - Do not use

## [2.0.44] - 2024-08-15

- REMOVED - Do not use

## [2.0.43] - 2024-08-16

- Renaming tag from name to account name

## [2.0.42] - 2024-08-16

- Add Gitlab ips for integrating with tfayx

## [2.0.41] - 2024-08-14

- Adding gcp-secrets to add pingone secrets to CP.
- Adding common_tags_cp to conform to GCP regular expression for labels (Doesn't like uppercase letters).

## [2.0.40] - 2024-08-15

- Add `ec2:TerminateInstances` policy to combability mode IAM role

## [2.0.39] - 2024-08-14

- Add clusterMode for memorydb

## [2.0.38] - 2024-08-12

- Pass CEFD container role ARN in kafka compatibility mode settings

## [2.0.37] - 2024-08-05

- Added Starayx auth pingone application.
- Added secret with pingone application details.

## [2.0.36] - 2024-08-05

- Updated starayx platform json to set dataplane.mode.

## [2.0.35] - 2024-08-05

- Add `KUBERNETES_VERSION` var that contains values for `k8sVersion` and `eksNodeAmi`
- This allows these values to be set as vars in tfcloud so k8s can be updated without cutting a new version
- Default value for this var should be removed once this is rolled out

## [2.0.34] - 2024-08-05

- Add Credentials Mgmt service infra

## [2.0.33] - 2024-07-31

- Update some deprecated fields
- Add EBS EKS addon
- Use the most recent versions of addons where possible. VPC-CNI we must catch up to avoid upgrading multiple minor versions at once.

## [2.0.32] - 2024-07-30

- Setting recovery windows in days to 0 for redis secret

## [2.0.31] - 2024-07-29

- CEFD IAM updates - TCIA-3959

## [2.0.30] - 2024-07-24

- Add `cloudwatch:PutMetricData` to `aws_iam_policy_document.compatibility_mode`
- Add cloudwatch to list of trusted entities in `aws_iam_policy_document.compatibility_mode_assume_role`

## [2.0.29] - 2024-07-24

- Enable memorydb provisioning for lowers

## [2.0.28] - 2024-07-23

- prevent CLOUD_EXECUTION_ENABLED to end as string instead of boolean

## [2.0.27] - 2024-07-17

- Add CLOUD_EXECUTION_ENGINE_VERSION to outputs

## [2.0.26] - 2024-07-17

- Add CLOUD_EXECUTION_ENGINE_VERSION variable
- Add MajorEngineVersion to kafka secret for CEFD
- Default now to 2023.1

## [2.0.25] - 2024-07-15

- Upgrade RDS postgres version to v15.5 and disallow automatic minor version upgrades

## [2.0.24] - 2024-07-12

- Add Kafka ACL for `cloudexecution-renderstatus` Kafka topic

## [2.0.23] - 2024-07-12

- Remove CEfD Kafka Topics becuase these topic should be created through the control-plane module.

## [2.0.22] - 2024-07-11

- Fix spelling mistake "rednerstatus" to "renderstatus"
- New keyboard... ;)

## [2.0.21] - 2024-07-10

- Add CEfD Kafka Topics for Analytics Apps
- [Kafka Topics](https://alteryx.atlassian.net/wiki/spaces/GAL/pages/2119892997/Kafka+Topics)

## [2.0.20] - 2024-07-09

- EKS 1.27
- Upgrade addons

## [2.0.19] - 2024-06-21

- Updated platform.json and init script for starayx.

## [2.0.18] - 2024-06-21

- EKS 1.26
- Upgrade addons

## [2.0.17] - 2024-06-21

- updated CLOUD_EXECUTION_AWS_AMI_NAME_PREFIX_REGEX to match the VM SDLC naming convention.

## [2.0.16] - 2024-06-05

- Added datadog api key to starayx instance.

## [2.0.15] - 2024-05-31

- Add ConcurrentRenderRuns in Appsetting secret key

## [2.0.14] - 2024-05-28

- JuiceFS Redis URL Change

## [2.0.13] - 2024-05-22

- Add logic to set starayx deployed to true if any of the following is set ENABLE_EMR_SERVERLESS, ENABLE_AIDIN, ENABLE_DC or ENABLE_AML
- else set to false

## [2.0.12] - 2024-05-22

- JuiceFS Bucket and Secret

## [2.0.11] - 2024-05-22

- EKS 1.25

## [2.0.10] - 2024-05-21

- pact-key secret for TCIA-3656

## [2.0.9] - 2024-05-06

- TCIA-3566 subnet updates for Starayx & Teleport Agent from option subnet to private subnet.
- EMR serverless subnet updates from private to option subnet.

## [2.0.8] - 2024-05-01

- Set enhanced_recording.enabled to true in teleport config

## [2.0.7] - 2024-05-01

- Changing the name of the startup script to match what the VM SDLC creates.

## [2.0.6] - 2024-04-25

- Use VM SDLC AMI images.
- Update init_script.sh.

## [2.0.5] - 2024-04-24

- TCIA-3604 update tfagent ip's changes

## [2.0.4] - 2024-04-18

- Fix Cyclic of eks-security-group and add conditions on juicefs

## [2.0.3] - 2024-04-08

- create wireguard private key secret placeholder

## [2.0.2] - 2024-04-05

- JuiceFS

## [2.0.1] - 2024-04-03

- Add kafka-cluster-rest-endpoint secret

## [2.0.0] - 2024-04-01

- Modularise AWS PDH

## [1.2.51] - 2024-03-21

- Add support for idle workers

## [1.2.50] - 2024-03-15

- revert cefd ami prefix to cefd-ltsc2022-2023-2-"

## [1.2.49] - 2024-03-14

- addtional fix for cefd ami prefix

## [1.2.48] - 2024-03-14

- fix cefd ami filter.

## [1.2.47] - 2024-03-14

- Update naming scheme.

## [1.2.46] - 2024-03-12

- eu-west-3 EC2 type fix

## [1.2.45] - 2024-03-12

- Default starayx feature flag to false

## [1.2.44] - 2024-03-12

- Adding instance refresh for starayx ASG.
- Remove unused aws_key_pair for the starayx VMs.

## [1.2.43] - 2024-03-12

- C5 EKS instances in eu-west-3

## [1.2.42] - 2024-03-12

- on_demand xml-amp pool defaults to zero

## [1.2.41] - 2024-03-08

- Common node pool changes
- XML-AMP (BullMQ) Nodepools

## [1.2.40] - 2024-03-06

- Update starayx output for kafka message.

## [1.2.39] - 2024-02-27

- Add starayx enabled output default to true.

## [1.2.38] - 2024-02-05

- Modify pingone config client_secret to contain the pingone application secret not the pingone worked secret.

## [1.2.37] - 2024-02-05

- Modify pingone config client_id to contain the pingone application id not the pingone worked id.

## [1.2.36] - 2024-02-02

- Removes TF management of the aws-auth configmap
- This is to be applied as a clean install or an upgrade AFTER aws-auth is manually removed from tfstate

## [1.2.35] - 2024-02-02

- CEFD AMI default prefix regex change

## [1.2.34] - 2024-02-02

- This release should only be used temporarily to fix the aws-auth configmap problem from 1.2.33.

## [1.2.33] - 2024-01-31

- Add cloud provider key pair for kafka secrets

## [1.2.32] - 2024-01-31

- Modifying pingone apiURL.

## [1.2.31] - 2024-01-30

- Adding EKS cluster CA cert to secret manager.
- Adding EKS cluster endpoint to secret manager.

## [1.2.30] - 2024-01-29

- New Names for Teleport TCP Apps, fixing potential Workspace ID collisions
- Removing management of aws_auth configmaps in all cases
- Moving sg logic for Teleport --> EKS to a new rule instead of a separate sg
- Update EKS config to allow cluster access from starayx security group

## [1.2.29] - 2024-01-12

- TSAASPD-3711 fix starayx teleport registration

## [1.2.28] - 2024-01-05

- Create Kafka resources independent of AiDIN enablement

## [1.2.27] - 2024-01-04

- Add starayx security group to launch template
- Remove ingress rule allowing UDP port 51820 inbound
- Add allow all egress rule as it's not automatically added

## [1.2.26] - 2024-01-03

- Private EKS Clusters using Teleport for ArgoCD, disabled by default

## [1.2.25] - 2023-12-18

- Starayx teleport agent registration on startup

## [1.2.24] - 2023-12-14

- Adding platform.json and adding EC2 Instance Connect Endpoint for Starayx.

## [1.2.23] - 2023-12-12

- Adjust outputs for aidin. Change SA ID value

## [1.2.22] - 2023-12-12

- Adjust outputs for aidin

## [1.2.21] - 2023-11-13

- Adjust outputs for aidin in event toggled off

## [1.2.20] - 2023-11-13

- Add outputs for AiDIN SA name + id

## [1.2.19] - 2023-09-30

- refactor + remove external gitlab.com dep

## [1.2.18] - 2023-09-25

- starayx module pingone integration

## [1.2.17] - 2023-10-16

- Aidin toggle global used for enable/disable of common-tooling applications need for Aidin

## [1.2.16] - 2023-10-16

- Aidin resources in submodule `data-plane-aidin`:
  - EFS
  - RDS
  - Secrets additions
  - Node groups for GPU and Big Iron
  - IAM checking for existing AiDIN policy changes
  - Submodule updates, specifically targeting provider constraints. Need `>=5.3.0`

## [1.2.15] - 2023-10-13

- [TSAASPD-3190] patch correct kafka_sa display name

## [1.2.14] - 2023-10-12

- Update Teleport autoscaling group from t2 to t3 because t3 is available in all regions we support

## [1.2.13] - 2023-09-25

- starayx module

## [1.2.12] - 2023-10-06

- [TSAASPD_3190] [TSAASPD-3191]: Aidin: adding kafka-cluster details kafka-sa to ASM

## [1.2.11] - 2023-09-19

- Update instance types supported by each region

## [1.2.10] - 2023-09-07

- Add lowers vs uppers cloud nat ips to EKS ingress

## [1.2.9] - 2023-09-06

- Filter fix for AMI for CEfD Teleport Agents also filters for linux kernel 6.1

## [1.2.8] - 2023-09-06

- Broken Version - AMI for CEfD Teleport Agents also filters for linux kernel 6.1

## [1.2.7] - 2023-09-06

- AMI for CEfD Teleport Agents uses the latest available Amazon Linux 2023.

## [1.2.6] - 2023-09-05

- Teleport Traffic goes to dedicated IP on port 443

## [1.2.5] - 2023-08-30

- Add control plane info in AWS SM for CEFD datadog logs seperation

## [1.2.4] - 2023-08-23

- instance type updates for multiregion cefd deployments

## [1.2.3] - 2023-08-22

- add node_group labels type=name

## [1.2.2] - 2023-08-22

- update new list of instance types for us-west-1 and eu-west-2

## [1.2.1] - 2023-08-22

- Teleport 13 Agents for CEfD

## [1.2.0] - 2023-08-21

- Modify PDP argo registration to use k8's secret instead of helm chart
- Might need a manual deletion of previous argo secret on PDH update scenarios, because of helm delete hook issue not deleting secret. Not a disruptive change.

## [1.1.2] - 2023-08-15

- add region specific instance types to support multi region PDH deployents
- <https://alteryx.atlassian.net/browse/TSAASPD-3127>

## [1.1.1] - 2023-08-15

- revert argo registration changes as part of 1.1.0
- Note: 1.1.0 is a Breaking change and not to be used

## [1.1.0] - 2023-08-15

- Modify PDP argo registration

## [1.0.17] - 2023-08-15

- update cefd userdata

## [1.0.16] - 2023-08-15

- Pass aac_resource_id for cefd

## [1.0.15] - 2023-08-14

- Reverting to Teleport 12

## [1.0.14] - 2023-08-14

- Teleport 12 Agent AMI Upgrade branching off 1.0.11.

## [1.0.13] - 2023-08-14

- Teleport Agent AMI Upgrade

## [1.0.12] - 2023-08-09

- Teleport 13

## [1.0.11] - 2023-08-08

- add tfcloud workspace and remove default value for structure

## [1.0.10] - 2023-08-08

- remove hardcoded teleport variable, empty state file

## [1.0.9] - 2023-08-03

- Remove tfvars and tfvars json
- Rename CEFD variable to CLOUD_EXECUTION_VERSION
- update CLOUD_EXECUTION_VERSION to pick correct value of CEFD version from infra service sent as a map

## [1.0.8] - 2023-08-02

- Handle Oauth secret deletion issue
- Add depends on fix for compatibility mode asg resource

## [1.0.7] - 2023-07-20

- gar secret in docker auth format to access gar with imagePullSecrets

## [1.0.6] - 2023-07-26

- Fixing locals file for Teleport Windows Agent AMI

## [1.0.5] - 2023-07-25

- Names that are unique per workspace for telelport/windows IAM and autoscaling groups

## [1.0.4] - 2023-07-20

- Update resource naming sequence
- Output updated credential encryption secret for kafka inputs

## [1.0.3] - 2023-07-17

- lower case label for cloud type

## [1.0.2] - 2023-07-17

- cleanup outputs

## [1.0.1] - 2023-07-17

- Fix oauth token name

## [1.0.0] - 2023-07-17

- multi-region support changes
- refactor modules, remove need for private-data-plane module
- support unique naming of secrets
- clean up of duplicate code

## [0.2.6] - 2023-07-11

- add back commented code

## [0.2.5] - 2023-07-11

- wip module

## [0.2.4] - 2023-07-11

- ci vars

## [0.2.3] - 2023-07-11

- rework eks providers things

## [0.2.2] - 2023-07-11

- fix previous

## [0.2.1] - 2023-07-11

- add wrapper code fromn the lowers/upper caller

## [0.2.0] - 2023-07-10 - all previous tags into newly 0.2.0

- [0.1.17] - 2023-07-10 - CEfD AMI Change that includes teleport installer
- [0.1.16] - 2023-07-10 - TSAASPD-2963: add sts:TagSession permission to the EMR Serverless execution role
- [0.1.15] - 2023-07-06 - Add schema information for CEfD - Change concurrent runs to 3
- [0.1.14] - 2023-07-03 - Datadog fix, Teleport labels
- [0.1.13] - 2023-06-28 - Teleport/Windows for Cloud Execution for Desktop
- [0.1.12] - 2023-06-27 - Tag bump for data-plane-private-helm, no new functionality
- [0.1.11] - 2023-06-26 - new version of data-plane-private-helm for teleport labels
- [0.1.10] - 2023-06-23 - add argocd bender server variables
- [0.1.9] - 2023-06-21 - Enable force deletion of emr s3 buckets
- [0.1.8] - 2023-06-21 - data-plane-compatibility-mode to v0.1.3 - Share only single AMI in CEfD - update kafka secrets with HealthCheckInterval, MemoryLimitBytes, WorkerTimeoutSeconds
- [0.1.7] - 2023-06-14 - SPIKE: disable vpce on cloud execution
- [0.1.6] - 2023-06-13 - SPIKE: fix module.emr is empty tuple. This value is null, so it does not have any attributes.
- [0.1.3] - 2023-06-13 - TSAASPD-2798: add cloud=aws label into dp cluster register into cp
- [0.1.2] - 2023-06-09 - SPIKE: TSAASPD-2682 and pin emr module to version 0.1.2
- [0.1.1] - 2023-06-08 - TSAASPD-2787: Pin the data-plane-compatibility-mode module to v0.1.1 from master
- [0.1.0] - 2023-06-05 - TSAASPD-2784: comaptibility-mode appsetting.json + move compatibility-mode dependant resources into compatibility-mode module
- [0.0.60] - 2023-06-02 - TSAASPD-2787 - Phase 1 of 2 for simplification of the SA/API KEY usage for Cloud Execution - We are removing the jobstatus producer SA/KEY and the associated ACLs - We are passing the topic name of the jobstatus topic via GSM secret into this code - NOTE: this name is being passed via GSM so any future potential change to this name will flow - downstream into this code without having to change this code - An ACL (WRITE) for the jobstatus topic will be added to the workspace defined SA/API key here
- [0.0.59] - 2023-06-01 - TSAASPD-2779 - Propagating ENABLE_CLOUD_EXECUTION and using to control creation of related topics in Kafka - Upstream uses should add 'enable_cloud_execution = var.ENABLE_CLOUD_EXECUTION' to the module definition - defaults to 'false' so upstream uses can continue without adding - be careful as resources have been created for many upstream uses, some should have been created, most didn't need to be
- [0.0.58] - 2023-06-01 - skip, empty tuple issues, need to wrap in try
- [0.0.57] - 2023-06-01 - skip, missed some count.index references
- [0.0.56] - 2023-06-01 - skip, missed some count.index references
- [0.0.55] - 2023-06-01 - skip, missed some count.index references
- [0.0.54] - 2023-06-01 - SPIKE: point to master as tag currently only existing on gitlab.com
- [0.0.53] - 2023-05-19 - TSAASPD-2587: Remove the default value for SEGMENTID
- [0.0.52] - 2023-05-19 - TSAASPD-2587: Change the Kafka SA for cloudexecution to READ from jobqueue and jobcancel
- [0.0.51] - 2023-05-19 - TSAASPD-2682: emr serveless output keys
- [0.0.50] - 2023-05-19 - SPIKE: attempt fix "Error: error creating Service Account "xxxxxx-cloudexecution-": 400 Bad Request: Invalid display name. Should start and end with alphanumeric and can contain hyphen/underscore/dot/colon"
- [0.0.49] - 2023-05-19 - TSAASPD-2682: emr serveless output : return {} when disabled
- [0.0.48] - 2023-05-18 - TSAASPD-2587: Create jobqueue and jobcancel topics and an SA API KEY for access
- [0.0.47] - 2023-05-18 - TSAASPD-2586: add kafka jobstatus topic SA API KEY and REST endpoint to AWS secret
- [0.0.46] - 2023-05-17 - TSAASPD-2682: return non empty when disabled
- [0.0.45] - 2023-05-17 - TSAASPD-2682: add enabled key into emr output
- [0.0.44] - 2023-05-08 - TSAASPD-2584: add tags to emr module call
- [0.0.43] - 2023-05-08 - TSAASPD-2584: add try function around the emr parameters
- [0.0.42] - 2023-05-08 - TSAASPD-2584: add try function around the emr parameters
- [0.0.41] - 2023-05-08 - TSAASPD-2584: add try function around the emr parameters
- [0.0.40] - 2023-05-08 - TSAASPD-2584: add try function around the emr parameters
- [0.0.39] - 2023-05-03 - TSAASPD-2584: added ENABLE_EMR_SERVERLESS
- [0.0.38] - 2023-04-26 - Remove traces of Account Alias
- [0.0.37] - 2023-04-26 - Update terraform lint job to `0.4`
- [0.0.36] - 2023-04-25 - Reduce wait time for fetching Oauth token
- [0.0.35] - 2023-04-25 - AWS s3 security updates
- [0.0.34] - 2023-04-24 - Reference to specific versions of EKS and EMR
- [0.0.33] - 2023-04-14 - Add emr serverless outputs
- [0.0.32] - 2023-04-10 - Update pdp globals on argocd labels
- [0.0.31] - 2023-03-30 - Increase time_sleep to 10min
- [0.0.30] - 2023-03-29 - Get oauth token from aws secret manager
- [0.0.29] - 2023-03-29 - Update ayx-argocd-external-secrets role poicy
- [0.0.28] - 2023-03-27 - remove allow of null in KubernetesConnectionInfo oauthToken
- [0.0.27] - 2023-03-27 - Remove duplicate helm providers - Add emr serverless outputs
- [0.0.26] - 2023-03-24 - GCII-367: PDH terraform outputs change.
- [0.0.25] - 2023-03-24 - GCII-367: PDP Infrastructure work for automating EMR serverless provisioning and configuration
- [0.0.24] - 2023-03-23 - revert time_sleep to 300s for oauthtoken dependency
- [0.0.23] - 2023-03-23 - Increase the time_sleep to 600s for oauthtoken dependency
- [0.0.22] - 2023-03-23 - Update helm.tf version to remove pdp helm terraform
- [0.0.21] - 2023-03-22 - Add resource time_sleep and helm.tf module - Replace null_resource with shell_script
- [0.0.20] - 2023-03-21 - Change common pool size to t3a.xlarge
- [0.0.19] - 2023-03-20 - Reverting openssl legacy changes
- [0.0.18] - 2023-03-17 - Fix escape error on script
- [0.0.17] - 2023-03-17 - Remove double quotes from script
- [0.0.16] - 2023-03-17 - Add legacy openssl
- [0.0.15] - 2023-03-14 - Update mmodule references
- [0.0.14] - 2023-03-10 - Remove unused s3 bucket
- [0.0.13] - 2023-03-08 - Allow for_each to use sensitive values
- [0.0.12] - 2023-03-07 - fix module source issue
- [0.0.11] - 2023-03-07 - update source url
- [0.0.10] - 2023-03-07 - update source url to ssh
- [0.0.9] - 2023-03-07 - update git url with user
- [0.0.8] - 2023-03-06 - update refernce to public gitlab for TFcloud
- [0.0.7] - 2023-03-06 - TSAASPD-1921 - TSAASPD-1982
- [0.0.6] - 2023-03-06 - Apply s3 bucket encryption
- [0.0.5] - 2023-03-01 - TSAASPD-1921: PDP Synchronize names, tags, resources with Whitepaper - TSAASPD-1982: SDP Infrastructure requests for EMR Serverless
- [0.0.4] - 2023-02-21 - TSAASPD-1924: Remove Trusted User as per IAM Policy White Paper
- [0.0.3] - 2023-02-07 - TSAASPD-1915: Adding dataservice-namespace namespace
- [0.0.2] - 2023-02-07 - TSAASPD-1786: emr serverless on data-plane-private
- [0.0.1] - 2023-01-02 - Initial commit
