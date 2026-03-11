data "alicloud_zones" "default" {
  available_disk_category     = "cloud_efficiency"
  available_resource_creation = "VSwitch"
}

data "alicloud_instance_types" "default" {
  availability_zone = data.alicloud_zones.default.zones[0].id
  cpu_core_count    = 2
  memory_size       = 4
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
  vpc_id  = data.alicloud_vpcs.default.ids[0]
  zone_id = data.alicloud_zones.default.zones[0].id
}

resource "alicloud_security_group" "default" {
  security_group_name = var.name
  vpc_id              = data.alicloud_vpcs.default.ids[0]
}

module "ess_autoscaling" {
  source = "../../"

  scaling_group_name = var.name
  min_size           = var.min_size
  max_size           = var.max_size
  desired_capacity   = var.desired_capacity
  vswitch_ids        = [data.alicloud_vswitches.default.vswitches[0].id]

  image_id             = data.alicloud_images.default.images[0].id
  instance_type        = data.alicloud_instance_types.default.instance_types[0].id
  security_group_ids   = [alicloud_security_group.default.id]
  system_disk_category = "cloud_efficiency"
  system_disk_size     = 40
  force_delete         = true

  tags = {
    Name        = var.name
    Environment = "test"
    ManagedBy   = "Terraform"
  }
}
