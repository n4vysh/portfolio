locals {
  project = read_terragrunt_config(find_in_parent_folders()).locals.name
  env = read_terragrunt_config(
    find_in_parent_folders("base/env.hcl")
  ).locals.env
  name = "${local.env.short}-${local.project}"

  providers = read_terragrunt_config(
    find_in_parent_folders("base/providers/generate.hcl")
  )
}

generate = {
  aws_provider = local.providers.generate["aws_provider"]
}

terraform {
  source = "tfr:///terraform-aws-modules/eks/aws//.?version=18.7.2"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id         = "temporary-dummy-id"
    public_subnets = ["temporary-dummy-subnet"]
  }
}

inputs = {
  cluster_name    = local.name
  cluster_version = "1.21"

  create_cloudwatch_log_group = false
  cluster_enabled_log_types   = []

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
      addon_version     = "v1.8.4-eksbuild.1"
    }
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
      addon_version     = "v1.21.2-eksbuild.2"
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
      addon_version     = "v1.10.2-eksbuild.1"
    }
  }

  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.public_subnets

  eks_managed_node_group_defaults = {
    instance_types = ["m5.xlarge"]
    capacity_type  = "SPOT"
  }

  eks_managed_node_groups = {
    "${local.name}-blue" = {
      ami_type = "BOTTLEROCKET_x86_64"
      platform = "bottlerocket"

      min_size     = 0
      max_size     = 1
      desired_size = 0

      bootstrap_extra_args = <<-EOT
        [settings.kubernetes]
        max-pods = 110
      EOT

      tags = {
        Project     = local.project
        Name        = "${local.name}-blue"
        Environment = local.env.long
      }
    }
    "${local.name}-green" = {
      ami_type = "BOTTLEROCKET_x86_64"
      platform = "bottlerocket"

      min_size     = 0
      max_size     = 1
      desired_size = 1

      bootstrap_extra_args = <<-EOT
        [settings.kubernetes]
        max-pods = 110
      EOT

      tags = {
        Project     = local.project
        Name        = "${local.name}-green"
        Environment = local.env.long
      }
    }
  }

  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    ingress_cluster_all = {
      description                   = "Cluster to node all ports/protocols"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      source_cluster_security_group = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
}
