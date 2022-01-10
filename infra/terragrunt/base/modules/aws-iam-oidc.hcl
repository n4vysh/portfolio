locals {
  project = read_terragrunt_config(find_in_parent_folders()).locals.name
  env = read_terragrunt_config(
    find_in_parent_folders("base/env.hcl")
  ).locals.env

  dir = one(
    regex(
      "environments/[^/]+/[^/]+/[^/]+/[^/]+/([^/]+)",
      get_original_terragrunt_dir()
    )
  )

  name = "${local.env.short}-${local.project}-${local.dir}"

  providers = read_terragrunt_config(
    find_in_parent_folders("base/providers/generate.hcl")
  )
}

generate = {
  aws_provider = local.providers.generate["aws_provider"]
}

terraform {
  source = "tfr:///terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc?version=4.9.0"
}

inputs = {
  create_role = true

  role_name = local.name

  tags = {
    Project     = local.project
    Name        = local.name
    Environment = local.env.long
  }
}
