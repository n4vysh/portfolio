locals {
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
  source = "tfr:///terraform-aws-modules/route53/aws//modules/records?version=2.5.0"
}

dependencies {
  paths = ["${get_terragrunt_dir()}/../../dnssec/${local.name}/"]
}

inputs = {
  zone_name = local.name
}
