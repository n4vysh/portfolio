locals {
  root = read_terragrunt_config(find_in_parent_folders()).locals
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
  source = "${dirname(find_in_parent_folders())}/../terraform/modules//aws-route53-dnssec"
}

dependencies {
  paths = ["${get_terragrunt_dir()}/../../zones/"]
}

inputs = {
  name = local.name
}
