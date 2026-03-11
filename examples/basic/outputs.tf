output "scaling_group_id" {
  description = "The ID of the scaling group"
  value       = module.ess_autoscaling.scaling_group_id
}

output "scaling_group_name" {
  description = "The name of the scaling group"
  value       = module.ess_autoscaling.scaling_group_name
}

output "scaling_configuration_id" {
  description = "The ID of the scaling configuration"
  value       = module.ess_autoscaling.scaling_configuration_id
}
