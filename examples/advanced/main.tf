data "alicloud_zones" "default" {
  available_disk_category     = "cloud_essd"
  available_resource_creation = "VSwitch"
}

data "alicloud_instance_types" "default" {
  availability_zone    = data.alicloud_zones.default.zones[0].id
  cpu_core_count       = 4
  memory_size          = 8
  system_disk_category = "cloud_essd"
}

data "alicloud_images" "default" {
  name_regex  = "^ubuntu_20.*64"
  most_recent = true
  owners      = "system"
}

data "alicloud_vpcs" "default" {
  name_regex = "^default-NODELETING$"
}

data "alicloud_vswitches" "default" {
  vpc_id = data.alicloud_vpcs.default.ids[0]
}

resource "alicloud_security_group" "default" {
  security_group_name = var.name
  vpc_id              = data.alicloud_vpcs.default.ids[0]
}

resource "alicloud_security_group_rule" "allow_http" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "80/80"
  priority          = 1
  security_group_id = alicloud_security_group.default.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_https" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "443/443"
  priority          = 1
  security_group_id = alicloud_security_group.default.id
  cidr_ip           = "0.0.0.0/0"
}

module "ess_autoscaling" {
  source = "../../"

  scaling_group_name        = var.name
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  default_cooldown          = 300
  vswitch_ids               = [for vs in slice(data.alicloud_vswitches.default.vswitches, 0, min(2, length(data.alicloud_vswitches.default.vswitches))) : vs.id]
  removal_policies          = ["OldestScalingConfiguration", "OldestInstance"]
  multi_az_policy           = "BALANCE"
  health_check_type         = "ECS"
  group_deletion_protection = false

  image_id             = data.alicloud_images.default.images[0].id
  instance_types       = [data.alicloud_instance_types.default.instance_types[0].id]
  security_group_ids   = [alicloud_security_group.default.id]
  system_disk_category = "cloud_essd"
  system_disk_size     = 100
  force_delete         = true

  data_disks = [
    {
      size                 = 100
      category             = "cloud_essd"
      delete_with_instance = true
      encrypted            = false
    }
  ]

  internet_max_bandwidth_out = 10
  internet_charge_type       = "PayByTraffic"

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx
    echo "Hello from ESS Instance $(hostname)" > /var/www/html/index.html
  EOF
  )

  create_scaling_rules = true
  scaling_rules = [
    {
      name             = "scale-out-rule"
      adjustment_type  = "QuantityChangeInCapacity"
      adjustment_value = 2
      cooldown         = 60
    },
    {
      name             = "scale-in-rule"
      adjustment_type  = "QuantityChangeInCapacity"
      adjustment_value = -1
      cooldown         = 60
    }
  ]

  tags = {
    Name        = var.name
    Environment = "production"
    ManagedBy   = "Terraform"
    Example     = "advanced"
  }
}
