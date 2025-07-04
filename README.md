# Purpose

Module Courtesy: **cloudposse**

Terraform module to provision an [`ElastiCache`](https://aws.amazon.com/elasticache/) Redis Cluster

---

[![Terraform Open Source Modules](https://docs.cloudposse.com/images/terraform-open-source-modules.svg)][terraform_modules]

It's 100% Open Source and licensed under the [APACHE2](LICENSE).

## Security & Compliance [<img src="https://cloudposse.com/wp-content/uploads/2020/11/bridgecrew.svg" width="250" align="right" />](https://bridgecrew.io/)

Security scanning is graciously provided by Bridgecrew. Bridgecrew is the leading fully hosted, cloud-native solution providing continuous Terraform security and compliance.

| Benchmark                                                                                                                                                                                                                                                               | Description                                                      |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| [![Infrastructure Security](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-elasticache-redis/general)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-elasticache-redis&benchmark=INFRASTRUCTURE+SECURITY) | Infrastructure Security Compliance                               |
| [![CIS KUBERNETES](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-elasticache-redis/cis_kubernetes)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-elasticache-redis&benchmark=CIS+KUBERNETES+V1.5)       | Center for Internet Security, KUBERNETES Compliance              |
| [![CIS AWS](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-elasticache-redis/cis_aws)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-elasticache-redis&benchmark=CIS+AWS+V1.2)                            | Center for Internet Security, AWS Compliance                     |
| [![CIS AZURE](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-elasticache-redis/cis_azure)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-elasticache-redis&benchmark=CIS+AZURE+V1.1)                      | Center for Internet Security, AZURE Compliance                   |
| [![PCI-DSS](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-elasticache-redis/pci)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-elasticache-redis&benchmark=PCI-DSS+V3.2)                                | Payment Card Industry Data Security Standards Compliance         |
| [![NIST-800-53](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-elasticache-redis/nist)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-elasticache-redis&benchmark=NIST-800-53)                            | National Institute of Standards and Technology Compliance        |
| [![ISO27001](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-elasticache-redis/iso)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-elasticache-redis&benchmark=ISO27001)                                   | Information Security Management System, ISO/IEC 27001 Compliance |
| [![SOC2](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-elasticache-redis/soc2)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-elasticache-redis&benchmark=SOC2)                                          | Service Organization Control 2 Compliance                        |
| [![CIS GCP](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-elasticache-redis/cis_gcp)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-elasticache-redis&benchmark=CIS+GCP+V1.1)                            | Center for Internet Security, GCP Compliance                     |
| [![HIPAA](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-elasticache-redis/hipaa)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-elasticache-redis&benchmark=HIPAA)                                       | Health Insurance Portability and Accountability Compliance       |

## Usage

**IMPORTANT:** We do not pin modules to versions in our examples because of the
difficulty of keeping the versions in the documentation in sync with the latest released versions.
We highly recommend that in your code you pin the version to the exact version you are
using so that your infrastructure remains stable, and update versions in a
systematic way so that they do not catch you by surprise.

Also, because of a bug in the Terraform registry ([hashicorp/terraform#21417](https://github.com/hashicorp/terraform/issues/21417)),
the registry shows many of our inputs as required when in fact they are optional.
The table below correctly indicates which inputs are required.

_**Disruptive changes introduced at version 0.41.0**. If upgrading from an earlier version, see
[migration notes](https://github.com/cloudposse/terraform-aws-elasticache-redis/blob/master/docs/migration-notes-0.41.0.md) for details._

Note that this uses secure defaults. One of the ways this module can trip users up is with `transit_encryption_enabled`
which is `true` by default. With this enabled, one does not simply `redis-cli` in without setting up an `stunnel`.
Amazon provides [good documentation on how to connect with it enabled](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html#connect-tls).
If this is not desired behavior, set `transit_encryption_enabled=false`.

This module creates, by default, a new security group for the Elasticache Redis Cluster. When a configuration
change (for example, a different security group name) cannot be applied to the security group, Terraform will
replace that security group with a new one with the new configuration. In order to allow Terraform to fully manage the security group, you
should not place any other resources in (or associate any other resources with) the security group this module
creates. Also, in order to keep things from breaking when this module replaces the security group, you should
not reference the created security group anywhere else (such as in rules in other security groups). If you
want to associate the cluster with a more stable security group that you can reference elsewhere, create that security group
outside this module (perhaps with [terraform-aws-security-group](https://github.com/cloudposse/terraform-aws-security-group))
and pass the security group ID in via `associated_security_group_ids`.

**Note about `zone_id`**: Previously, `zone_id` was a string. This caused problems (see [#82](https://github.com/cloudposse/terraform-aws-elasticache-redis/issues/82)).
Now `zone_id` should be supplied as a `list(string)`, either empty or with exactly 1 zone ID in order to avoid the problem.

For a complete example, see [examples/complete](examples/complete).

For automated tests of the complete example using [bats](https://github.com/bats-core/bats-core) and [Terratest](https://github.com/gruntwork-io/terratest) (which tests and deploys the example on AWS), see [test](test).

```hcl
provider "aws" {
  region = var.region
}

module "this" {
  source  = "app.terraform.io/studiographene/label/null"
  # version = "x.x.x"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
}

module "vpc" {
  source = "cloudposse/vpc/aws"
  # version = "x.x.x"

  cidr_block = "172.16.0.0/16"

  context = module.this.context
}

module "subnets" {
  source = "cloudposse/dynamic-subnets/aws"
  # version = "x.x.x"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = true
  nat_instance_enabled = false

  context = module.this.context
}

module "redis" {
  source = "cloudposse/elasticache-redis/aws"
  # version = "x.x.x"

  availability_zones         = var.availability_zones
  zone_id                    = var.zone_id
  vpc_id                     = module.vpc.vpc_id
  allowed_security_group_ids = [module.vpc.vpc_default_security_group_id]
  subnets                    = module.subnets.private_subnet_ids
  cluster_size               = var.cluster_size
  instance_type              = var.instance_type
  apply_immediately          = true
  automatic_failover_enabled = false
  engine_version             = var.engine_version
  family                     = var.family
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled

  parameter = [
    {
      name  = "notify-keyspace-events"
      value = "lK"
    }
  ]

  context = module.this.context
}
```

## Examples

Review the [complete example](examples/complete) to see how to use this module.

<!-- markdownlint-disable -->

## Makefile Targets

```text
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint terraform code

```

<!-- markdownlint-restore -->
<!-- markdownlint-disable -->

## Requirements

| Name                                                                     | Version |
| ------------------------------------------------------------------------ | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.3  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 4.18 |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | >= 4.18 |

## Modules

| Name                                                                                      | Source                                  | Version |
| ----------------------------------------------------------------------------------------- | --------------------------------------- | ------- |
| <a name="module_aws_security_group"></a> [aws_security_group](#module_aws_security_group) | cloudposse/security-group/aws           | 1.0.1   |
| <a name="module_dns"></a> [dns](#module_dns)                                              | cloudposse/route53-cluster-hostname/aws | 0.12.2  |
| <a name="module_this"></a> [this](#module_this)                                           | cloudposse/label/null                   | 0.25.0  |

## Resources

| Name                                                                                                                                                   | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| [aws_cloudwatch_metric_alarm.cache_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm)           | resource |
| [aws_cloudwatch_metric_alarm.cache_memory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm)        | resource |
| [aws_elasticache_parameter_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group)     | resource |
| [aws_elasticache_replication_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group)           | resource |

## Inputs

| Name                                                                                                                                          | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | Type           | Default                                                                                                                                                                                                                                                                                                                                                                                                                                                           | Required |
| --------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------: | --- | --- |
| <a name="input_additional_tag_map"></a> [additional_tag_map](#input_additional_tag_map)                                                       | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration.                                                                                                                                                                                                                                                                                                                                                                                   | `map(string)`  | `{}`                                                                                                                                                                                                                                                                                                                                                                                                                                                              |    no    |
| <a name="input_alarm_actions"></a> [alarm_actions](#input_alarm_actions)                                                                      | Alarm action list                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `list(string)` | `[]`                                                                                                                                                                                                                                                                                                                                                                                                                                                              |    no    |
| <a name="input_alarm_cpu_threshold_percent"></a> [alarm_cpu_threshold_percent](#input_alarm_cpu_threshold_percent)                            | CPU threshold alarm level                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `number`       | `75`                                                                                                                                                                                                                                                                                                                                                                                                                                                              |    no    |
| <a name="input_alarm_memory_threshold_bytes"></a> [alarm_memory_threshold_bytes](#input_alarm_memory_threshold_bytes)                         | Ram threshold alarm level                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `number`       | `10000000`                                                                                                                                                                                                                                                                                                                                                                                                                                                        |    no    |
| <a name="input_apply_immediately"></a> [apply_immediately](#input_apply_immediately)                                                          | Apply changes immediately                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `bool`         | `true`                                                                                                                                                                                                                                                                                                                                                                                                                                                            |    no    |     | no  |
| <a name="input_at_rest_encryption_enabled"></a> [at_rest_encryption_enabled](#input_at_rest_encryption_enabled)                               | Enable encryption at rest                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `bool`         | `false`                                                                                                                                                                                                                                                                                                                                                                                                                                                           |    no    |
| <a name="input_attributes"></a> [attributes](#input_attributes)                                                                               | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element.                                                                                                                                                                                                                                                                                                                                                                                        | `list(string)` | `[]`                                                                                                                                                                                                                                                                                                                                                                                                                                                              |    no    |
| <a name="input_auth_token"></a> [auth_token](#input_auth_token)                                                                               | Auth token for password protecting redis, `transit_encryption_enabled` must be set to `true`. Password must be longer than 16 chars                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | `string`       | `null`                                                                                                                                                                                                                                                                                                                                                                                                                                                            |    no    |
| <a name="input_auto_minor_version_upgrade"></a> [auto_minor_version_upgrade](#input_auto_minor_version_upgrade)                               | Specifies whether minor version engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. Only supported if the engine version is 6 or higher.                                                                                                                                                                                                                                                                                                                                                                                                                                                          | `bool`         | `null`                                                                                                                                                                                                                                                                                                                                                                                                                                                            |    no    |
| <a name="input_automatic_failover_enabled"></a> [automatic_failover_enabled](#input_automatic_failover_enabled)                               | Automatic failover (Not available for T1/T2 instances)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | `bool`         | `false`                                                                                                                                                                                                                                                                                                                                                                                                                                                           |    no    |
| <a name="input_availability_zones"></a> [availability_zones](#input_availability_zones)                                                       | Availability zone IDs                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | `list(string)` | `[]`                                                                                                                                                                                                                                                                                                                                                                                                                                                              |    no    |
| <a name="input_cloudwatch_metric_alarms_enabled"></a> [cloudwatch_metric_alarms_enabled](#input_cloudwatch_metric_alarms_enabled)             | Boolean flag to enable/disable CloudWatch metrics alarms                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | `bool`         | `false`                                                                                                                                                                                                                                                                                                                                                                                                                                                           |    no    |
| <a name="input_cluster_mode_enabled"></a> [cluster_mode_enabled](#input_cluster_mode_enabled)                                                 | Flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | `bool`         | `false`                                                                                                                                                                                                                                                                                                                                                                                                                                                           |    no    |
| <a name="input_cluster_mode_num_node_groups"></a> [cluster_mode_num_node_groups](#input_cluster_mode_num_node_groups)                         | Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | `number`       | `0`                                                                                                                                                                                                                                                                                                                                                                                                                                                               |    no    |
| <a name="input_cluster_mode_replicas_per_node_group"></a> [cluster_mode_replicas_per_node_group](#input_cluster_mode_replicas_per_node_group) | Number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | `number`       | `0`                                                                                                                                                                                                                                                                                                                                                                                                                                                               |    no    |
| <a name="input_cluster_size"></a> [cluster_size](#input_cluster_size)                                                                         | Number of nodes in cluster. _Ignored when `cluster_mode_enabled` == `true`_                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | `number`       | `1`                                                                                                                                                                                                                                                                                                                                                                                                                                                               |    no    |
| <a name="input_context"></a> [context](#input_context)                                                                                        | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional_tag_map, which are merged.                                                                                                                                                                                                                                                                                                                            | `any`          | <pre>{<br> "additional_tag_map": {},<br> "attributes": [],<br> "delimiter": null,<br> "descriptor_formats": {},<br> "enabled": true,<br> "environment": null,<br> "id_length_limit": null,<br> "label_key_case": null,<br> "label_order": [],<br> "label_value_case": null,<br> "labels_as_tags": [<br> "unset"<br> ],<br> "name": null,<br> "namespace": null,<br> "regex_replace_chars": null,<br> "stage": null,<br> "tags": {},<br> "tenant": null<br>}</pre> |    no    |
| <a name="input_data_tiering_enabled"></a> [data_tiering_enabled](#input_data_tiering_enabled)                                                 | Enables data tiering. Data tiering is only supported for replication groups using the r6gd node type.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | `bool`         | `false`                                                                                                                                                                                                                                                                                                                                                                                                                                                           |    no    |
| <a name="input_delimiter"></a> [delimiter](#input_delimiter)                                                                                  | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | `string`       | `null`                                                                                                                                                                                                                                                                                                                                                                                                                                                            |    no    |
| <a name="input_description"></a> [description](#input_description)                                                                            | Description of elasticache replication group                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | `string`       | `null`                                                                                                                                                                                                                                                                                                                                                                                                                                                            |    no    |
| <a name="input_descriptor_formats"></a> [descriptor_formats](#input_descriptor_formats)                                                       | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any`          | `{}`                                                                                                                                                                                                                                                                                                                                                                                                                                                              |    no    |
| <a name="input_dns_subdomain"></a> [dns_subdomain](#input_dns_subdomain)                                                                      | The subdomain to use for the CNAME record. If not provided then the CNAME record will use var.name.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | `string`       | `""`                                                                                                                                                                                                                                                                                                                                                                                                                                                              |    no    |

| <a name="input_elasticache_subnet_group_name"></a> [elasticache_subnet_group_name](#input_elasticache_subnet_group_name) | Subnet group name for the ElastiCache instance | `string` | `""` | no |
| <a name="input_enabled"></a> [enabled](#input_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_engine_version"></a> [engine_version](#input_engine_version) | Redis engine version | `string` | `"4.0.10"` | no |
| <a name="input_environment"></a> [environment](#input_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_family"></a> [family](#input_family) | Redis family | `string` | `"redis4.0"` | no |
| <a name="input_final_snapshot_identifier"></a> [final_snapshot_identifier](#input_final_snapshot_identifier) | The name of your final node group (shard) snapshot. ElastiCache creates the snapshot from the primary node in the cluster. If omitted, no final snapshot will be made. | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id_length_limit](#input_id_length_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_instance_type"></a> [instance_type](#input_instance_type) | Elastic cache instance type | `string` | `"cache.t2.micro"` | no |
| <a name="input_kms_key_id"></a> [kms_key_id](#input_kms_key_id) | The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. `at_rest_encryption_enabled` must be set to `true` | `string` | `null` | no |
| <a name="input_label_key_case"></a> [label_key_case](#input_label_key_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label_order](#input_label_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label_value_case](#input_label_value_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels_as_tags](#input_labels_as_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br> The value of the `name` tag, if included, will be the `id`, not the `name`.<br> Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br> changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br> "default"<br>]</pre> | no |
| <a name="input_log_delivery_configuration"></a> [log_delivery_configuration](#input_log_delivery_configuration) | The log_delivery_configuration block allows the streaming of Redis SLOWLOG or Redis Engine Log to CloudWatch Logs or Kinesis Data Firehose. Max of 2 blocks. | `list(map(any))` | `[]` | no |
| <a name="input_maintenance_window"></a> [maintenance_window](#input_maintenance_window) | Maintenance window | `string` | `"wed:03:00-wed:04:00"` | no |
| <a name="input_multi_az_enabled"></a> [multi_az_enabled](#input_multi_az_enabled) | Multi AZ (Automatic Failover must also be enabled. If Cluster Mode is enabled, Multi AZ is on by default, and this setting is ignored) | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_notification_topic_arn"></a> [notification_topic_arn](#input_notification_topic_arn) | Notification topic arn | `string` | `""` | no |
| <a name="input_ok_actions"></a> [ok_actions](#input_ok_actions) | The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Number (ARN) | `list(string)` | `[]` | no |
| <a name="input_parameter"></a> [parameter](#input_parameter) | A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another | <pre>list(object({<br> name = string<br> value = string<br> }))</pre> | `[]` | no |
| <a name="input_parameter_group_description"></a> [parameter_group_description](#input_parameter_group_description) | Managed by Terraform | `string` | `null` | no |
| <a name="input_port"></a> [port](#input_port) | Redis port | `number` | `6379` | no |
| <a name="input_regex_replace_chars"></a> [regex_replace_chars](#input_regex_replace_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_replication_group_id"></a> [replication_group_id](#input_replication_group_id) | Replication group ID with the following constraints: <br>A name must contain from 1 to 20 alphanumeric characters or hyphens. <br> The first character must be a letter. <br> A name cannot end with a hyphen or contain two consecutive hyphens. | `string` | `""` | no |
| <a name="input_snapshot_arns"></a> [snapshot_arns](#input_snapshot_arns) | A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. Example: arn:aws:s3:::my_bucket/snapshot1.rdb | `list(string)` | `[]` | no |
| <a name="input_snapshot_name"></a> [snapshot_name](#input_snapshot_name) | The name of a snapshot from which to restore data into the new node group. Changing the snapshot_name forces a new resource. | `string` | `null` | no |
| <a name="input_snapshot_retention_limit"></a> [snapshot_retention_limit](#input_snapshot_retention_limit) | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. | `number` | `0` | no |
| <a name="input_snapshot_window"></a> [snapshot_window](#input_snapshot_window) | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. | `string` | `"06:30-07:30"` | no |
| <a name="input_stage"></a> [stage](#input_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_subnets"></a> [subnets](#input_subnets) | Subnet IDs | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_transit_encryption_enabled"></a> [transit_encryption_enabled](#input_transit_encryption_enabled) | Set `true` to enable encryption in transit. Forced `true` if `var.auth_token` is set.<br>If this is enabled, use the [following guide](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html#connect-tls) to access redis. | `bool` | `true` | no |
| <a name="input_user_group_ids"></a> [user_group_ids](#input_user_group_ids) | User Group ID to associate with the replication group | `list(string)` | `null` | no |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id) | VPC ID | `string` | n/a | yes |
| <a name="input_zone_id"></a> [zone_id](#input_zone_id) | Route53 DNS Zone ID as list of string (0 or 1 items). If empty, no custom DNS name will be published.<br>If the list contains a single Zone ID, a custom DNS name will be pulished in that zone.<br>Can also be a plain string, but that use is DEPRECATED because of Terraform issues. | `any` | `[]` | no |
| <a name="input_ingress_cidr_blocks"></a>[ingress_cidr_blocks](#ingress_cidr_blocks) | List of IPv4 CIDR ranges to allow in security group ingress.                                                     |  `list(string)` | `[]` | no |      |
| <a name="input_allowed_security_groups"></a>[allowed_security_groups](#allowed_security_groups) | List of security group IDs to allow in security group ingress.                           |  `list(string)` | `[]` | no |
| <a name="intra_security_group_traffic_enabled"></a>[intra_security_group_traffic_enabled](#intra_security_group_traffic_enabled) | Whether to allow traffic between resources inside the database's security group.                           |  `boolean` | `false` | no |

## Outputs

| Name                                                                                                     | Description                                                                                                |
| -------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| <a name="output_arn"></a> [arn](#output_arn)                                                             | Elasticache Replication Group ARN                                                                          |
| <a name="output_cluster_enabled"></a> [cluster_enabled](#output_cluster_enabled)                         | Indicates if cluster mode is enabled                                                                       |
| <a name="output_endpoint"></a> [endpoint](#output_endpoint)                                              | Redis primary or configuration endpoint, whichever is appropriate for the given cluster mode               |
| <a name="output_engine_version_actual"></a> [engine_version_actual](#output_engine_version_actual)       | The running version of the cache engine                                                                    |
| <a name="output_host"></a> [host](#output_host)                                                          | Redis hostname                                                                                             |
| <a name="output_id"></a> [id](#output_id)                                                                | Redis cluster ID                                                                                           |
| <a name="output_member_clusters"></a> [member_clusters](#output_member_clusters)                         | Redis cluster members                                                                                      |
| <a name="output_port"></a> [port](#output_port)                                                          | Redis port                                                                                                 |
| <a name="output_reader_endpoint_address"></a> [reader_endpoint_address](#output_reader_endpoint_address) | The address of the endpoint for the reader node in the replication group, if the cluster mode is disabled. |
| <a name="output_security_group_id"></a> [security_group_id](#output_security_group_id)                   | The ID of the created security group                                                                       |
| <a name="output_security_group_name"></a> [security_group_name](#output_security_group_name)             | The name of the created security group                                                                     |

<!-- markdownlint-restore -->

## Share the Love

Like this project? Please give it a ★ on [our GitHub](https://github.com/cloudposse/terraform-aws-elasticache-redis)! (it helps us **a lot**)

Are you using this project or any of our other projects? Consider [leaving a testimonial][testimonial]. =)

## Related Projects

Check out these related projects.

- [terraform-aws-security-group](https://github.com/cloudposse/terraform-aws-security-group) - Terraform module to provision an AWS Security Group.
- [terraform-null-label](https://github.com/cloudposse/terraform-null-label) - Terraform module designed to generate consistent names and tags for resources. Use terraform-null-label to implement a strict naming convention.

## Help

**Got a question?** We got answers.

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-elasticache-redis/issues), send us an [email][email] or join our [Slack Community][slack].

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]

## DevOps Accelerator for Startups

We are a [**DevOps Accelerator**][commercial_support]. We'll help you build your cloud infrastructure from the ground up so you can own it. Then we'll show you how to operate it and stick around for as long as you need us.

[![Learn More](https://img.shields.io/badge/learn%20more-success.svg?style=for-the-badge)][commercial_support]

Work directly with our team of DevOps experts via email, slack, and video conferencing.

We deliver 10x the value for a fraction of the cost of a full-time engineer. Our track record is not even funny. If you want things done right and you need it done FAST, then we're your best bet.

- **Reference Architecture.** You'll get everything you need from the ground up built using 100% infrastructure as code.
- **Release Engineering.** You'll have end-to-end CI/CD with unlimited staging environments.
- **Site Reliability Engineering.** You'll have total visibility into your apps and microservices.
- **Security Baseline.** You'll have built-in governance with accountability and audit logs for all changes.
- **GitOps.** You'll be able to operate your infrastructure via Pull Requests.
- **Training.** You'll receive hands-on training so your team can operate what we build.
- **Questions.** You'll have a direct line of communication between our teams via a Shared Slack channel.
- **Troubleshooting.** You'll get help to triage when things aren't working.
- **Code Reviews.** You'll receive constructive feedback on Pull Requests.
- **Bug Fixes.** We'll rapidly work with you to fix any bugs in our projects.

## Slack Community

Join our [Open Source Community][slack] on Slack. It's **FREE** for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build totally _sweet_ infrastructure.

## Discourse Forums

Participate in our [Discourse Forums][discourse]. Here you'll find answers to commonly asked questions. Most questions will be related to the enormous number of projects we support on our GitHub. Come here to collaborate on answers, find solutions, and get ideas about the products and services we value. It only takes a minute to get started! Just sign in with SSO using your GitHub account.

## Newsletter

Sign up for [our newsletter][newsletter] that covers everything on our technology radar. Receive updates on what we're up to on GitHub as well as awesome new projects we discover.

## Office Hours

[Join us every Wednesday via Zoom][office_hours] for our weekly "Lunch & Learn" sessions. It's **FREE** for everyone!

[![zoom](https://img.cloudposse.com/fit-in/200x200/https://cloudposse.com/wp-content/uploads/2019/08/Powered-by-Zoom.png")][office_hours]

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-elasticache-redis/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing this project or [help out](https://cpco.io/help-out) with our other projects, we would love to hear from you! Shoot us an [email][email].

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

1.  **Fork** the repo on GitHub
2.  **Clone** the project to your own machine
3.  **Commit** changes to your own branch
4.  **Push** your work back up to your fork
5.  Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!

## Copyright

Copyright © 2017-2023 [Cloud Posse, LLC](https://cpco.io/copyright)

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

```text
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
```

## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know by [leaving a testimonial][testimonial]!

[![Cloud Posse][logo]][website]

We're a [DevOps Professional Services][hire] company based in Los Angeles, CA. We ❤️ [Open Source Software][we_love_open_source].

We offer [paid support][commercial_support] on all of our projects.

Check out [our other projects][github], [follow us on twitter][twitter], [apply for a job][jobs], or [hire us][hire] to help with your cloud strategy and implementation.

### Contributors

<!-- markdownlint-disable -->

| [![Erik Osterman][osterman_avatar]][osterman_homepage]<br/>[Erik Osterman][osterman_homepage] | [![Igor Rodionov][goruha_avatar]][goruha_homepage]<br/>[Igor Rodionov][goruha_homepage] | [![Andriy Knysh][aknysh_avatar]][aknysh_homepage]<br/>[Andriy Knysh][aknysh_homepage] | [![Daren Desjardins][darend_avatar]][darend_homepage]<br/>[Daren Desjardins][darend_homepage] | [![Max Moon][MoonMoon1919_avatar]][MoonMoon1919_homepage]<br/>[Max Moon][MoonMoon1919_homepage] | [![Christopher Riley][christopherriley_avatar]][christopherriley_homepage]<br/>[Christopher Riley][christopherriley_homepage] | [![RB][nitrocode_avatar]][nitrocode_homepage]<br/>[RB][nitrocode_homepage] |
| --------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |

<!-- markdownlint-restore -->

[osterman_homepage]: https://github.com/osterman
[osterman_avatar]: https://img.cloudposse.com/150x150/https://github.com/osterman.png
[goruha_homepage]: https://github.com/goruha
[goruha_avatar]: https://img.cloudposse.com/150x150/https://github.com/goruha.png
[aknysh_homepage]: https://github.com/aknysh
[aknysh_avatar]: https://img.cloudposse.com/150x150/https://github.com/aknysh.png
[darend_homepage]: https://github.com/darend
[darend_avatar]: https://img.cloudposse.com/150x150/https://github.com/darend.png
[MoonMoon1919_homepage]: https://github.com/MoonMoon1919
[MoonMoon1919_avatar]: https://img.cloudposse.com/150x150/https://github.com/MoonMoon1919.png
[christopherriley_homepage]: https://github.com/christopherriley
[christopherriley_avatar]: https://img.cloudposse.com/150x150/https://github.com/christopherriley.png
[nitrocode_homepage]: https://github.com/nitrocode
[nitrocode_avatar]: https://img.cloudposse.com/150x150/https://github.com/nitrocode.png

[![README Footer][readme_footer_img]][readme_footer_link]
[![Beacon][beacon]][website]

<!-- markdownlint-disable -->

[logo]: https://cloudposse.com/logo-300x69.svg
[docs]: https://cpco.io/docs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=docs
[website]: https://cpco.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=website
[github]: https://cpco.io/github?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=github
[jobs]: https://cpco.io/jobs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=jobs
[hire]: https://cpco.io/hire?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=hire
[slack]: https://cpco.io/slack?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=slack
[linkedin]: https://cpco.io/linkedin?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=linkedin
[twitter]: https://cpco.io/twitter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=twitter
[testimonial]: https://cpco.io/leave-testimonial?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=testimonial
[office_hours]: https://cloudposse.com/office-hours?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=office_hours
[newsletter]: https://cpco.io/newsletter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=newsletter
[discourse]: https://ask.sweetops.com/?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=discourse
[email]: https://cpco.io/email?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=email
[commercial_support]: https://cpco.io/commercial-support?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=commercial_support
[we_love_open_source]: https://cpco.io/we-love-open-source?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=we_love_open_source
[terraform_modules]: https://cpco.io/terraform-modules?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=terraform_modules
[readme_header_img]: https://cloudposse.com/readme/header/img
[readme_header_link]: https://cloudposse.com/readme/header/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=readme_header_link
[readme_footer_img]: https://cloudposse.com/readme/footer/img
[readme_footer_link]: https://cloudposse.com/readme/footer/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=readme_footer_link
[readme_commercial_support_img]: https://cloudposse.com/readme/commercial-support/img
[readme_commercial_support_link]: https://cloudposse.com/readme/commercial-support/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-elasticache-redis&utm_content=readme_commercial_support_link
[share_twitter]: https://twitter.com/intent/tweet/?text=terraform-aws-elasticache-redis&url=https://github.com/cloudposse/terraform-aws-elasticache-redis
[share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=terraform-aws-elasticache-redis&url=https://github.com/cloudposse/terraform-aws-elasticache-redis
[share_reddit]: https://reddit.com/submit/?url=https://github.com/cloudposse/terraform-aws-elasticache-redis
[share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/cloudposse/terraform-aws-elasticache-redis
[share_googleplus]: https://plus.google.com/share?url=https://github.com/cloudposse/terraform-aws-elasticache-redis
[share_email]: mailto:?subject=terraform-aws-elasticache-redis&body=https://github.com/cloudposse/terraform-aws-elasticache-redis
[beacon]: https://ga-beacon.cloudposse.com/UA-76589703-4/cloudposse/terraform-aws-elasticache-redis?pixel&cs=github&cm=readme&an=terraform-aws-elasticache-redis

<!-- markdownlint-restore -->
