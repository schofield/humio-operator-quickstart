# example changes for 100TB/day scale
# use for reference

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "humio_instance_type" {
  type    = string
  default = "i3.8xlarge" # Instance should have local NVME
}

# Note at 100TB/day rate will only allow 15 days nvme storage on this node type
# Assuming 10x compression
variable "humio_instance_count" {
  type    = number
  default = 51
}

# using i3en.24xlarge
# variable "humio_instance_type" {
#   type    = string
#   default = "i3en.24xlarge" # Instance should have local NVME
# }

# Note at 100TB/day rate will allows 52 days nvme storage on this node type
# Assuming 10x compression
# variable "humio_instance_count" {
#   type    = number
#   default = 18 
# }


variable "kafka_instance_type" {
  type    = string
  default = "kafka.m5.2xlarge"
}

variable "kafka_instance_count" {
  type    = number
  default = 12
}

variable "kafka_version" {
  type    = string
  default = "2.8.1"
}

# sized to keep 24 hours of data if needed
variable "kafka_volume_size" {
  type    = number
  default = 5000
}

variable "humio_data_dir" {
  type    = string
  default = "/mnt/disks/vol1"
}
variable "humio_data_dir_owner_uuid" {
  type    = number
  default = 65534
}
variable "user_data_script" {
  type    = string
  default = "user-data.sh.tmpl"
}
variable "namespace" {
  type    = string
  default = "logging"
}
variable "service_account_name" {
  type    = string
  default = "humio-quickstart-humio"
}

variable "environment" {
  type    = string
  default = "Production"
}
variable "owner" {
  type    = string
  default = "humio"
}
