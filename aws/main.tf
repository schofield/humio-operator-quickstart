terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = ">= 2.28.1"
  region  = var.region
}

provider "random" {
  version = "~> 2.1"
}

provider "local" {
  version = "~> 1.2"
}

locals {
  cluster_name = "humio-quickstart-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
}
