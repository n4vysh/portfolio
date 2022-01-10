locals {
  root = read_terragrunt_config(find_in_parent_folders()).locals
  env  = read_terragrunt_config("${dirname(find_in_parent_folders(""))}/base/env.hcl").locals.env

  path = one(
    regex(
      "environments/[^/]+/[^/]+/([^/]+)",
      get_original_terragrunt_dir()
    )
  )
  name = "${local.env.short}-${local.root.user}-${local.path}"

  providers = read_terragrunt_config(
    find_in_parent_folders("base/providers/generate.hcl")
  )
}

generate = {
  aws_provider = local.providers.generate["aws_provider"]
}

terraform {
  source = "tfr:///terraform-aws-modules/s3-bucket/aws//.?version=2.14.1"
}

inputs = {
  bucket = "${local.name}"

  tags = {
    Project     = local.root.name
    Name        = local.name
    Environment = local.env.long
  }
}
