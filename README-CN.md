阿里云弹性伸缩服务（ESS）Terraform 模块

# terraform-alicloud-ess-autoscaling

[English](https://github.com/alibabacloud-automation/terraform-alicloud-ess-autoscaling/blob/main/README.md) | 简体中文

用于在阿里云上创建[弹性伸缩服务（ESS）](https://help.aliyun.com/zh/ess/)资源的 Terraform 模块，为 ECS 实例提供自动伸缩能力。本模块管理 ESS 资源的完整生命周期，包括伸缩组、伸缩配置、伸缩规则、定时任务、通知和生命周期挂钩。

## 使用方法

创建一个包含基本伸缩配置的 ESS 自动伸缩组。

```terraform
module "ess_autoscaling" {
  source = "alibabacloud-automation/ess-autoscaling/alicloud"

  scaling_group_name = "my-web-servers"
  min_size           = 1
  max_size           = 10
  desired_capacity   = 3
  vswitch_ids        = ["vsw-abc123", "vsw-def456"]

  image_id             = "ubuntu_20_04_x64_20G_alibase"
  instance_type        = "ecs.g6.large"
  security_group_ids   = ["sg-abc123"]
  system_disk_category = "cloud_essd"
  system_disk_size     = 40

  tags = {
    Environment = "production"
  }
}
```

## 示例

* [基础示例](https://github.com/alibabacloud-automation/terraform-alicloud-ess-autoscaling/tree/main/examples/basic)
* [高级示例](https://github.com/alibabacloud-automation/terraform-alicloud-ess-autoscaling/tree/main/examples/advanced)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.141.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | 1.272.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_ess_lifecycle_hook.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ess_lifecycle_hook) | resource |
| [alicloud_ess_notification.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ess_notification) | resource |
| [alicloud_ess_scaling_configuration.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ess_scaling_configuration) | resource |
| [alicloud_ess_scaling_group.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ess_scaling_group) | resource |
| [alicloud_ess_scaling_rule.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ess_scaling_rule) | resource |
| [alicloud_ess_scheduled_task.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ess_scheduled_task) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active"></a> [active](#input\_active) | Whether to activate the scaling configuration | `bool` | `true` | no |
| <a name="input_create_scaling_configuration"></a> [create\_scaling\_configuration](#input\_create\_scaling\_configuration) | Controls whether scaling configuration should be created | `bool` | `true` | no |
| <a name="input_create_scaling_group"></a> [create\_scaling\_group](#input\_create\_scaling\_group) | Controls whether scaling group should be created | `bool` | `true` | no |
| <a name="input_create_scaling_rules"></a> [create\_scaling\_rules](#input\_create\_scaling\_rules) | Controls whether scaling rules should be created | `bool` | `false` | no |
| <a name="input_create_scheduled_tasks"></a> [create\_scheduled\_tasks](#input\_create\_scheduled\_tasks) | Controls whether scheduled tasks should be created | `bool` | `false` | no |
| <a name="input_data_disks"></a> [data\_disks](#input\_data\_disks) | List of data disk configurations for instances created by the scaling configuration | <pre>list(object({<br/>    size                 = optional(number, 20)<br/>    category             = optional(string, "cloud_efficiency")<br/>    delete_with_instance = optional(bool, true)<br/>    encrypted            = optional(bool, false)<br/>    kms_key_id           = optional(string, null)<br/>    performance_level    = optional(string, null)<br/>    snapshot_id          = optional(string, null)<br/>    name                 = optional(string, null)<br/>    description          = optional(string, null)<br/>  }))</pre> | `[]` | no |
| <a name="input_db_instance_ids"></a> [db\_instance\_ids](#input\_db\_instance\_ids) | List of RDS instance IDs to which the scaling group's ECS instances will be attached | `list(string)` | `[]` | no |
| <a name="input_default_cooldown"></a> [default\_cooldown](#input\_default\_cooldown) | The default cooldown time in seconds. Range: [0, 86400] | `number` | `300` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | The expected number of ECS instances in the scaling group. Range: [min\_size, max\_size] | `number` | `null` | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | Whether to force delete the last scaling configuration when deleting the scaling group | `bool` | `false` | no |
| <a name="input_group_deletion_protection"></a> [group\_deletion\_protection](#input\_group\_deletion\_protection) | Whether to enable deletion protection for the scaling group | `bool` | `false` | no |
| <a name="input_health_check_type"></a> [health\_check\_type](#input\_health\_check\_type) | Health check type for the scaling group. Options: ECS, ECI, NONE, LOAD\_BALANCER | `string` | `"ECS"` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | The ID of the image used to create ECS instances | `string` | `null` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | The name of the ECS instances created by the scaling configuration | `string` | `"ESS-Instance"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The ECS instance type. Used when a single instance type is needed | `string` | `null` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | List of ECS instance types for multi-instance-type support. Takes precedence over instance\_type | `list(string)` | `[]` | no |
| <a name="input_internet_charge_type"></a> [internet\_charge\_type](#input\_internet\_charge\_type) | The network billing type. Options: PayByBandwidth, PayByTraffic | `string` | `"PayByBandwidth"` | no |
| <a name="input_internet_max_bandwidth_out"></a> [internet\_max\_bandwidth\_out](#input\_internet\_max\_bandwidth\_out) | The maximum outbound bandwidth from the public network in Mbps. Range: [0, 1024] | `number` | `0` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The name of the key pair for SSH login | `string` | `null` | no |
| <a name="input_lifecycle_hook_config"></a> [lifecycle\_hook\_config](#input\_lifecycle\_hook\_config) | Configuration for ESS lifecycle hooks that execute custom actions during instance launch or termination | <pre>object({<br/>    enabled               = bool<br/>    name                  = optional(string, null)<br/>    lifecycle_transition  = optional(string, "SCALE_OUT")<br/>    heartbeat_timeout     = optional(number, 600)<br/>    default_result        = optional(string, "CONTINUE")<br/>    notification_metadata = optional(string, null)<br/>  })</pre> | <pre>{<br/>  "default_result": "CONTINUE",<br/>  "enabled": false,<br/>  "heartbeat_timeout": 600,<br/>  "lifecycle_transition": "SCALE_OUT",<br/>  "name": null,<br/>  "notification_metadata": null<br/>}</pre> | no |
| <a name="input_loadbalancer_ids"></a> [loadbalancer\_ids](#input\_loadbalancer\_ids) | List of SLB instance IDs to which the scaling group's ECS instances will be attached | `list(string)` | `[]` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum number of ECS instances in the scaling group. Range: [0, 2000] | `number` | `1` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum number of ECS instances in the scaling group. Range: [0, 2000] | `number` | `0` | no |
| <a name="input_multi_az_policy"></a> [multi\_az\_policy](#input\_multi\_az\_policy) | Multi-AZ scaling group ECS instance expansion strategy. Options: PRIORITY, COMPOSABLE, BALANCE, COST\_OPTIMIZED | `string` | `"PRIORITY"` | no |
| <a name="input_notification_config"></a> [notification\_config](#input\_notification\_config) | Configuration for ESS scaling event notifications via MNS | <pre>object({<br/>    enabled          = bool<br/>    notification_arn = optional(string, null)<br/>    notification_types = optional(list(string), [<br/>      "AUTOSCALING:SCALE_OUT_SUCCESS",<br/>      "AUTOSCALING:SCALE_OUT_ERROR",<br/>      "AUTOSCALING:SCALE_IN_SUCCESS",<br/>      "AUTOSCALING:SCALE_IN_ERROR",<br/>    ])<br/>  })</pre> | <pre>{<br/>  "enabled": false,<br/>  "notification_arn": null,<br/>  "notification_types": [<br/>    "AUTOSCALING:SCALE_OUT_SUCCESS",<br/>    "AUTOSCALING:SCALE_OUT_ERROR",<br/>    "AUTOSCALING:SCALE_IN_SUCCESS",<br/>    "AUTOSCALING:SCALE_IN_ERROR"<br/>  ]<br/>}</pre> | no |
| <a name="input_password_inherit"></a> [password\_inherit](#input\_password\_inherit) | Whether to use the password predefined in the image | `bool` | `false` | no |
| <a name="input_removal_policies"></a> [removal\_policies](#input\_removal\_policies) | List of removal policies to select ECS instances for removal. Options: OldestInstance, NewestInstance, OldestScalingConfiguration | `list(string)` | <pre>[<br/>  "OldestScalingConfiguration",<br/>  "OldestInstance"<br/>]</pre> | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | The RAM role name for the ECS instances | `string` | `null` | no |
| <a name="input_scaling_configuration_name"></a> [scaling\_configuration\_name](#input\_scaling\_configuration\_name) | The name of the scaling configuration. Must contain 2-64 characters | `string` | `null` | no |
| <a name="input_scaling_group_name"></a> [scaling\_group\_name](#input\_scaling\_group\_name) | The name of the scaling group. Must contain 2-64 characters | `string` | `null` | no |
| <a name="input_scaling_rules"></a> [scaling\_rules](#input\_scaling\_rules) | List of scaling rule configurations | <pre>list(object({<br/>    name              = string<br/>    adjustment_type   = optional(string, "TotalCapacity")<br/>    adjustment_value  = optional(number, 1)<br/>    cooldown          = optional(number, null)<br/>    scaling_rule_type = optional(string, "SimpleScalingRule")<br/>    metric_name       = optional(string, null)<br/>    target_value      = optional(number, null)<br/>    disable_scale_in  = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_scheduled_tasks"></a> [scheduled\_tasks](#input\_scheduled\_tasks) | List of scheduled task configurations | <pre>list(object({<br/>    name                   = string<br/>    scheduled_action       = string<br/>    recurrence_type        = optional(string, null)<br/>    recurrence_value       = optional(string, null)<br/>    launch_time            = optional(string, null)<br/>    launch_expiration_time = optional(number, 600)<br/>    min_value              = optional(number, null)<br/>    max_value              = optional(number, null)<br/>    desired_capacity       = optional(number, null)<br/>  }))</pre> | `[]` | no |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | The ID of the security group. Used when a single security group is needed (conflicts with security\_group\_ids) | `string` | `null` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs. Takes precedence over security\_group\_id (conflicts with security\_group\_id) | `list(string)` | `[]` | no |
| <a name="input_system_disk_category"></a> [system\_disk\_category](#input\_system\_disk\_category) | The category of the system disk. Options: cloud\_efficiency, cloud\_ssd, cloud\_essd | `string` | `"cloud_efficiency"` | no |
| <a name="input_system_disk_performance_level"></a> [system\_disk\_performance\_level](#input\_system\_disk\_performance\_level) | The performance level of the ESSD used as system disk. Options: PL0, PL1, PL2, PL3 | `string` | `null` | no |
| <a name="input_system_disk_size"></a> [system\_disk\_size](#input\_system\_disk\_size) | The size of the system disk in GiB. Range: [20, 2048] | `number` | `40` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the scaling group resources | `map(string)` | `{}` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | User-defined data to customize the startup behaviors of the ECS instance | `string` | `null` | no |
| <a name="input_vswitch_ids"></a> [vswitch\_ids](#input\_vswitch\_ids) | List of VSwitch IDs in which the ECS instances will be launched | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lifecycle_hook_id"></a> [lifecycle\_hook\_id](#output\_lifecycle\_hook\_id) | The ID of the lifecycle hook |
| <a name="output_lifecycle_hook_name"></a> [lifecycle\_hook\_name](#output\_lifecycle\_hook\_name) | The name of the lifecycle hook |
| <a name="output_notification_id"></a> [notification\_id](#output\_notification\_id) | The ID of the notification configuration |
| <a name="output_scaling_configuration_id"></a> [scaling\_configuration\_id](#output\_scaling\_configuration\_id) | The ID of the scaling configuration |
| <a name="output_scaling_configuration_name"></a> [scaling\_configuration\_name](#output\_scaling\_configuration\_name) | The name of the scaling configuration |
| <a name="output_scaling_group_desired_capacity"></a> [scaling\_group\_desired\_capacity](#output\_scaling\_group\_desired\_capacity) | The desired capacity of the scaling group |
| <a name="output_scaling_group_id"></a> [scaling\_group\_id](#output\_scaling\_group\_id) | The ID of the scaling group |
| <a name="output_scaling_group_max_size"></a> [scaling\_group\_max\_size](#output\_scaling\_group\_max\_size) | The maximum size of the scaling group |
| <a name="output_scaling_group_min_size"></a> [scaling\_group\_min\_size](#output\_scaling\_group\_min\_size) | The minimum size of the scaling group |
| <a name="output_scaling_group_name"></a> [scaling\_group\_name](#output\_scaling\_group\_name) | The name of the scaling group |
| <a name="output_scaling_rule_arns"></a> [scaling\_rule\_arns](#output\_scaling\_rule\_arns) | The ARNs (ARIs) of the scaling rules |
| <a name="output_scaling_rule_ids"></a> [scaling\_rule\_ids](#output\_scaling\_rule\_ids) | The IDs of the scaling rules |
| <a name="output_scheduled_task_ids"></a> [scheduled\_task\_ids](#output\_scheduled\_task\_ids) | The IDs of the scheduled tasks |
<!-- END_TF_DOCS -->

## 提交问题

如果您在使用此模块时遇到任何问题，请提交一个 [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) 并告知我们。

**注意：** 不建议在此仓库中提交问题。

## 作者

由阿里云 Terraform 团队创建和维护(terraform@alibabacloud.com)。

## 许可证

MIT 许可。有关完整详细信息，请参阅 LICENSE。

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
