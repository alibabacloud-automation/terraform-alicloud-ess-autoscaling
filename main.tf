# Copyright 2024 Alibaba Cloud
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

resource "alicloud_ess_scaling_group" "this" {
  count = var.create_scaling_group ? 1 : 0

  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  scaling_group_name        = var.scaling_group_name
  default_cooldown          = var.default_cooldown
  vswitch_ids               = var.vswitch_ids
  removal_policies          = var.removal_policies
  db_instance_ids           = var.db_instance_ids
  loadbalancer_ids          = var.loadbalancer_ids
  multi_az_policy           = var.multi_az_policy
  health_check_type         = var.health_check_type
  group_deletion_protection = var.group_deletion_protection
  tags                      = var.tags
}

resource "alicloud_ess_scaling_configuration" "this" {
  count = var.create_scaling_group && var.create_scaling_configuration ? 1 : 0

  scaling_group_id              = alicloud_ess_scaling_group.this[0].id
  scaling_configuration_name    = var.scaling_configuration_name
  image_id                      = var.image_id
  instance_type                 = local.instance_type
  instance_types                = local.instance_types
  security_group_id             = local.security_group_id
  security_group_ids            = local.security_group_ids
  instance_name                 = var.instance_name
  internet_charge_type          = var.internet_charge_type
  internet_max_bandwidth_out    = var.internet_max_bandwidth_out
  system_disk_category          = var.system_disk_category
  system_disk_size              = var.system_disk_size
  system_disk_performance_level = var.system_disk_performance_level
  user_data                     = var.user_data
  key_name                      = var.key_name
  role_name                     = var.role_name
  password_inherit              = var.password_inherit
  force_delete                  = var.force_delete
  active                        = var.active
  tags                          = var.tags

  dynamic "data_disk" {
    for_each = var.data_disks

    content {
      size                 = data_disk.value.size
      category             = data_disk.value.category
      delete_with_instance = data_disk.value.delete_with_instance
      encrypted            = data_disk.value.encrypted
      kms_key_id           = data_disk.value.kms_key_id
      performance_level    = data_disk.value.performance_level
      snapshot_id          = data_disk.value.snapshot_id
      name                 = data_disk.value.name
      description          = data_disk.value.description
    }
  }
}

resource "alicloud_ess_scaling_rule" "this" {
  for_each = var.create_scaling_group && var.create_scaling_rules ? {
    for idx, rule in var.scaling_rules : rule.name => rule
  } : {}

  scaling_group_id  = alicloud_ess_scaling_group.this[0].id
  scaling_rule_name = each.value.name
  adjustment_type   = each.value.adjustment_type
  adjustment_value  = each.value.adjustment_value
  cooldown          = each.value.cooldown
  scaling_rule_type = each.value.scaling_rule_type
  metric_name       = each.value.metric_name
  target_value      = each.value.target_value
  disable_scale_in  = each.value.disable_scale_in
}

resource "alicloud_ess_scheduled_task" "this" {
  for_each = var.create_scaling_group && var.create_scheduled_tasks ? {
    for idx, task in var.scheduled_tasks : task.name => task
  } : {}

  scheduled_task_name    = each.value.name
  scheduled_action       = "${alicloud_ess_scaling_group.this[0].id}:${each.value.scheduled_action}"
  recurrence_type        = each.value.recurrence_type
  recurrence_value       = each.value.recurrence_value
  launch_time            = each.value.launch_time
  launch_expiration_time = each.value.launch_expiration_time
  min_value              = each.value.min_value
  max_value              = each.value.max_value
  desired_capacity       = each.value.desired_capacity
}

resource "alicloud_ess_notification" "this" {
  count = var.create_scaling_group && var.notification_config.enabled ? 1 : 0

  scaling_group_id   = alicloud_ess_scaling_group.this[0].id
  notification_arn   = var.notification_config.notification_arn
  notification_types = var.notification_config.notification_types
}

resource "alicloud_ess_lifecycle_hook" "this" {
  count = var.create_scaling_group && var.lifecycle_hook_config.enabled ? 1 : 0

  scaling_group_id      = alicloud_ess_scaling_group.this[0].id
  name                  = var.lifecycle_hook_config.name
  lifecycle_transition  = var.lifecycle_hook_config.lifecycle_transition
  heartbeat_timeout     = var.lifecycle_hook_config.heartbeat_timeout
  default_result        = var.lifecycle_hook_config.default_result
  notification_metadata = var.lifecycle_hook_config.notification_metadata
}
