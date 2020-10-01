provider "template" {
  version = "~> 2.1"
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}

resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "worker_group_mgmt_one"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}

resource "aws_security_group" "eks_msk" {
  name   = "${local.cluster_name}-msk"
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = local.cluster_name
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "v12.2.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.17"
  subnets         = module.vpc.private_subnets
  enable_irsa     = true

  tags = {
    Name = local.cluster_name
  }

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "worker-group"
      instance_type                 = var.humio_instance_type
      additional_userdata           = templatefile("${path.module}/${var.user_data_script}", { humio_data_dir = var.humio_data_dir, humio_data_dir_owner_uuid = var.humio_data_dir_owner_uuid})
      asg_desired_capacity          = var.humio_instance_count
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id, aws_security_group.eks_msk.id]
    }
  ]
}
