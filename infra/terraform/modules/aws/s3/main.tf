terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.0.5"
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Environment = var.env.full
    }
  }
}

locals {
  name = "${var.env.short}.${var.name}.${var.domain}"
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = var.policy_actions

    resources = [
      "arn:aws:s3:::${local.name}/*",
      "arn:aws:s3:::${local.name}",
    ]
  }
}

module "bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.11.1"

  bucket = local.name

  tags = {
    Name = local.name
  }
}

module "user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "4.7.0"

  name          = replace(local.name, ".", "-")
  force_destroy = true

  # pgp_key argument is maintenance-only mode
  # https://github.com/hashicorp/terraform-provider-aws/issues/15384
  # pgp_key = ""

  create_iam_user_login_profile = false

  tags = {
    Name = replace(local.name, ".", "-")
  }
}

module "iam_group_with_policies" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "~> 4.3"

  name = replace(local.name, ".", "-")

  group_users = [
    replace(local.name, ".", "-"),
  ]

  attach_iam_self_management_policy = false

  custom_group_policies = [
    {
      name   = replace(local.name, ".", "-")
      policy = data.aws_iam_policy_document.this.json
    }
  ]

  tags = {
    Name = replace(local.name, ".", "-")
  }
}

output "access_key" {
  value     = module.user.iam_access_key_id
  sensitive = true
}

output "secret_key" {
  value     = module.user.iam_access_key_secret
  sensitive = true
}
