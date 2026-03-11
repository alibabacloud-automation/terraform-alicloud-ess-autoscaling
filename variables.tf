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

#------------------------------------------------------------------------------
# Scaling Group
#------------------------------------------------------------------------------

variable "create_scaling_group" {
  description = "Controls whether scaling group should be created"
  type        = bool
  default     = true
}

variable "scaling_group_name" {
  description = "The name of the scaling group. Must contain 2-64 characters"
  type        = string
  default     = null
}

variable "min_size" {
  description = "The minimum number of ECS instances in the scaling group. Range: [0, 2000]"
  type        = number
  default     = 0
}

variable "max_size" {
  description = "The maximum number of ECS instances in the scaling group. Range: [0, 2000]"
  type        = number
  default     = 1
}

variable "desired_capacity" {
  description = "The expected number of ECS instances in the scaling group. Range: [min_size, max_size]"
  type        = number
  default     = null
}

variable "default_cooldown" {
  description = "The default cooldown time in seconds. Range: [0, 86400]"
  type        = number
  default     = 300
}

variable "vswitch_ids" {
  description = "List of VSwitch IDs in which the ECS instances will be launched"
  type        = list(string)
  default     = []
}

variable "removal_policies" {
  description = "List of removal policies to select ECS instances for removal. Options: OldestInstance, NewestInstance, OldestScalingConfiguration"
  type        = list(string)
  default     = ["OldestScalingConfiguration", "OldestInstance"]
}

variable "db_instance_ids" {
  description = "List of RDS instance IDs to which the scaling group's ECS instances will be attached"
  type        = list(string)
  default     = []
}

variable "loadbalancer_ids" {
  description = "List of SLB instance IDs to which the scaling group's ECS instances will be attached"
  type        = list(string)
  default     = []
}

variable "multi_az_policy" {
  description = "Multi-AZ scaling group ECS instance expansion strategy. Options: PRIORITY, COMPOSABLE, BALANCE, COST_OPTIMIZED"
  type        = string
  default     = "PRIORITY"
}

variable "health_check_type" {
  description = "Health check type for the scaling group. Options: ECS, ECI, NONE, LOAD_BALANCER"
  type        = string
  default     = "ECS"
}

variable "group_deletion_protection" {
  description = "Whether to enable deletion protection for the scaling group"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the scaling group resources"
  type        = map(string)
  default     = {}
}

#------------------------------------------------------------------------------
# Scaling Configuration
#------------------------------------------------------------------------------

variable "create_scaling_configuration" {
  description = "Controls whether scaling configuration should be created"
  type        = bool
  default     = true
}

variable "scaling_configuration_name" {
  description = "The name of the scaling configuration. Must contain 2-64 characters"
  type        = string
  default     = null
}

variable "image_id" {
  description = "The ID of the image used to create ECS instances"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "The ECS instance type. Used when a single instance type is needed"
  type        = string
  default     = null
}

variable "instance_types" {
  description = "List of ECS instance types for multi-instance-type support. Takes precedence over instance_type"
  type        = list(string)
  default     = []
}

variable "security_group_id" {
  description = "The ID of the security group. Used when a single security group is needed (conflicts with security_group_ids)"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "List of security group IDs. Takes precedence over security_group_id (conflicts with security_group_id)"
  type        = list(string)
  default     = []
}

variable "instance_name" {
  description = "The name of the ECS instances created by the scaling configuration"
  type        = string
  default     = "ESS-Instance"
}

variable "internet_charge_type" {
  description = "The network billing type. Options: PayByBandwidth, PayByTraffic"
  type        = string
  default     = "PayByBandwidth"
}

variable "internet_max_bandwidth_out" {
  description = "The maximum outbound bandwidth from the public network in Mbps. Range: [0, 1024]"
  type        = number
  default     = 0
}

variable "system_disk_category" {
  description = "The category of the system disk. Options: cloud_efficiency, cloud_ssd, cloud_essd"
  type        = string
  default     = "cloud_efficiency"
}

variable "system_disk_size" {
  description = "The size of the system disk in GiB. Range: [20, 2048]"
  type        = number
  default     = 40
}

variable "system_disk_performance_level" {
  description = "The performance level of the ESSD used as system disk. Options: PL0, PL1, PL2, PL3"
  type        = string
  default     = null
}

variable "data_disks" {
  description = "List of data disk configurations for instances created by the scaling configuration"
  type = list(object({
    size                 = optional(number, 20)
    category             = optional(string, "cloud_efficiency")
    delete_with_instance = optional(bool, true)
    encrypted            = optional(bool, false)
    kms_key_id           = optional(string, null)
    performance_level    = optional(string, null)
    snapshot_id          = optional(string, null)
    name                 = optional(string, null)
    description          = optional(string, null)
  }))
  default = []
}

variable "user_data" {
  description = "User-defined data to customize the startup behaviors of the ECS instance"
  type        = string
  default     = null
}

variable "key_name" {
  description = "The name of the key pair for SSH login"
  type        = string
  sensitive   = true
  default     = null
}

variable "role_name" {
  description = "The RAM role name for the ECS instances"
  type        = string
  default     = null
}

variable "password_inherit" {
  description = "Whether to use the password predefined in the image"
  type        = bool
  default     = false
}

variable "force_delete" {
  description = "Whether to force delete the last scaling configuration when deleting the scaling group"
  type        = bool
  default     = false
}

variable "active" {
  description = "Whether to activate the scaling configuration"
  type        = bool
  default     = true
}

#------------------------------------------------------------------------------
# Scaling Rules
#------------------------------------------------------------------------------

variable "create_scaling_rules" {
  description = "Controls whether scaling rules should be created"
  type        = bool
  default     = false
}

variable "scaling_rules" {
  description = "List of scaling rule configurations"
  type = list(object({
    name              = string
    adjustment_type   = optional(string, "TotalCapacity")
    adjustment_value  = optional(number, 1)
    cooldown          = optional(number, null)
    scaling_rule_type = optional(string, "SimpleScalingRule")
    metric_name       = optional(string, null)
    target_value      = optional(number, null)
    disable_scale_in  = optional(bool, false)
  }))
  default = []
}

#------------------------------------------------------------------------------
# Scheduled Tasks
#------------------------------------------------------------------------------

variable "create_scheduled_tasks" {
  description = "Controls whether scheduled tasks should be created"
  type        = bool
  default     = false
}

variable "scheduled_tasks" {
  description = "List of scheduled task configurations"
  type = list(object({
    name                   = string
    scheduled_action       = string
    recurrence_type        = optional(string, null)
    recurrence_value       = optional(string, null)
    launch_time            = optional(string, null)
    launch_expiration_time = optional(number, 600)
    min_value              = optional(number, null)
    max_value              = optional(number, null)
    desired_capacity       = optional(number, null)
  }))
  default = []
}

#------------------------------------------------------------------------------
# Notification Configuration (aggregated)
#------------------------------------------------------------------------------

variable "notification_config" {
  description = "Configuration for ESS scaling event notifications via MNS"
  type = object({
    enabled          = bool
    notification_arn = optional(string, null)
    notification_types = optional(list(string), [
      "AUTOSCALING:SCALE_OUT_SUCCESS",
      "AUTOSCALING:SCALE_OUT_ERROR",
      "AUTOSCALING:SCALE_IN_SUCCESS",
      "AUTOSCALING:SCALE_IN_ERROR",
    ])
  })
  default = {
    enabled          = false
    notification_arn = null
    notification_types = [
      "AUTOSCALING:SCALE_OUT_SUCCESS",
      "AUTOSCALING:SCALE_OUT_ERROR",
      "AUTOSCALING:SCALE_IN_SUCCESS",
      "AUTOSCALING:SCALE_IN_ERROR",
    ]
  }
}

#------------------------------------------------------------------------------
# Lifecycle Hook Configuration (aggregated)
#------------------------------------------------------------------------------

variable "lifecycle_hook_config" {
  description = "Configuration for ESS lifecycle hooks that execute custom actions during instance launch or termination"
  type = object({
    enabled               = bool
    name                  = optional(string, null)
    lifecycle_transition  = optional(string, "SCALE_OUT")
    heartbeat_timeout     = optional(number, 600)
    default_result        = optional(string, "CONTINUE")
    notification_metadata = optional(string, null)
  })
  default = {
    enabled               = false
    name                  = null
    lifecycle_transition  = "SCALE_OUT"
    heartbeat_timeout     = 600
    default_result        = "CONTINUE"
    notification_metadata = null
  }
}
