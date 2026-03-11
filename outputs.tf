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

output "scaling_group_id" {
  description = "The ID of the scaling group"
  value       = try(alicloud_ess_scaling_group.this[0].id, null)
}

output "scaling_group_name" {
  description = "The name of the scaling group"
  value       = try(alicloud_ess_scaling_group.this[0].scaling_group_name, null)
}

output "scaling_group_min_size" {
  description = "The minimum size of the scaling group"
  value       = try(alicloud_ess_scaling_group.this[0].min_size, null)
}

output "scaling_group_max_size" {
  description = "The maximum size of the scaling group"
  value       = try(alicloud_ess_scaling_group.this[0].max_size, null)
}

output "scaling_group_desired_capacity" {
  description = "The desired capacity of the scaling group"
  value       = try(alicloud_ess_scaling_group.this[0].desired_capacity, null)
}

output "scaling_configuration_id" {
  description = "The ID of the scaling configuration"
  value       = try(alicloud_ess_scaling_configuration.this[0].id, null)
}

output "scaling_configuration_name" {
  description = "The name of the scaling configuration"
  value       = try(alicloud_ess_scaling_configuration.this[0].scaling_configuration_name, null)
}

output "scaling_rule_ids" {
  description = "The IDs of the scaling rules"
  value       = { for k, v in alicloud_ess_scaling_rule.this : k => v.id }
}

output "scaling_rule_arns" {
  description = "The ARNs (ARIs) of the scaling rules"
  value       = { for k, v in alicloud_ess_scaling_rule.this : k => v.ari }
}

output "scheduled_task_ids" {
  description = "The IDs of the scheduled tasks"
  value       = { for k, v in alicloud_ess_scheduled_task.this : k => v.id }
}

output "notification_id" {
  description = "The ID of the notification configuration"
  value       = try(alicloud_ess_notification.this[0].id, null)
}

output "lifecycle_hook_id" {
  description = "The ID of the lifecycle hook"
  value       = try(alicloud_ess_lifecycle_hook.this[0].id, null)
}

output "lifecycle_hook_name" {
  description = "The name of the lifecycle hook"
  value       = try(alicloud_ess_lifecycle_hook.this[0].name, null)
}
