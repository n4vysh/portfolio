locals {
  root = read_terragrunt_config(find_in_parent_folders()).locals
  env = read_terragrunt_config(
    find_in_parent_folders("base/env.hcl")
  ).locals.env

  providers = read_terragrunt_config(
    find_in_parent_folders("base/providers/generate.hcl")
  )
}

generate = {
  aws_provider = local.providers.generate["aws_provider"]
}

terraform {
  source = "${dirname(find_in_parent_folders())}/../terraform/modules//aws-load-balancer"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id         = "temporary-dummy-id"
    public_subnets = ["temporary-dummy-subnet"]
  }
}

dependency "storage_alb" {
  config_path = "../storage/alb"

  mock_outputs = {
    s3_bucket_id = "temporary-dummy-id"
  }
}

inputs = {
  domain     = local.env.short == "prd" ? local.root.domain : "${local.env.short}.${local.root.domain}"
  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.public_subnets
  bucket_id = {
    lb = dependency.storage_alb.outputs.s3_bucket_id
  }
}
