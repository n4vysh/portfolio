locals {
  project = read_terragrunt_config(find_in_parent_folders()).locals.name
  env = read_terragrunt_config(
    find_in_parent_folders("base/env.hcl")
  ).locals.env
  name = "${local.env.short}-${local.project}"
}

dependency "data_aws_az" {
  config_path = "../data/aws-az"

  mock_outputs = {
    names = [
      "temporary-dummy-az-name-1",
      "temporary-dummy-az-name-2",
      "temporary-dummy-az-name-3",
    ]
  }
}

terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws//.?version=3.12.0"
}

inputs = {
  name = local.name
  cidr = "10.0.0.0/16"

  azs = dependency.data_aws_az.outputs.names
  public_subnets = formatlist(
    "10.0.%d.0/24",
    range(1, 1 + length(dependency.data_aws_az.outputs.names))
  )

  tags = {
    Project     = local.project
    Name        = local.name
    Environment = local.env.long
  }
}
