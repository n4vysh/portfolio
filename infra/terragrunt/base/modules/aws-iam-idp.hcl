locals {
  project = read_terragrunt_config(find_in_parent_folders()).locals.name
  env = read_terragrunt_config(
    find_in_parent_folders("base/env.hcl")
  ).locals.env

  name = one(
    regex(
      "environments/[^/]+/[^/]+/[^/]+/([^/]+)",
      get_original_terragrunt_dir()
    )
  )

  providers = read_terragrunt_config(
    find_in_parent_folders("base/providers/generate.hcl")
  )
}

generate = {
  aws_provider = local.providers.generate["aws_provider"]
}

terraform {
  source = "${dirname(find_in_parent_folders())}/../terraform/modules//aws-iam-idp"
}

inputs = {
  name = local.name

  tags = {
    Project     = local.project
    Name        = local.name
    Environment = local.env.long
  }
}
