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

locals {
  # Determine whether to use single instance_type or instance_types list
  use_instance_types = length(var.instance_types) > 0
  instance_type      = local.use_instance_types ? null : var.instance_type
  instance_types     = local.use_instance_types ? var.instance_types : null

  # Determine whether to use single security_group_id or security_group_ids list
  use_security_group_ids = length(var.security_group_ids) > 0
  security_group_id      = local.use_security_group_ids ? null : var.security_group_id
  security_group_ids     = local.use_security_group_ids ? var.security_group_ids : null
}
