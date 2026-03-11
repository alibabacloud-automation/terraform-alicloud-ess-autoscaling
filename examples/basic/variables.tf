variable "name" {
  description = "The name prefix for all resources"
  type        = string
  default     = "ess-basic-example"
}

variable "min_size" {
  description = "The minimum number of ECS instances in the scaling group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum number of ECS instances in the scaling group"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "The desired number of ECS instances in the scaling group"
  type        = number
  default     = 2
}
