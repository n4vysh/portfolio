locals {
  root = read_terragrunt_config(find_in_parent_folders()).locals
  env  = read_terragrunt_config("${dirname(find_in_parent_folders(""))}/base/env.hcl").locals.env

  zones = compact(
    [
      local.env.short == "prd" ? local.root.domain : "",
      local.env.short == "stg" ? "${local.env.short}.${local.root.domain}" : "",
    ]
  )

  providers = read_terragrunt_config(
    find_in_parent_folders("base/providers/generate.hcl")
  )
}

generate = {
  aws_provider = local.providers.generate["aws_provider"]
}

terraform {
  source = "tfr:///terraform-aws-modules/route53/aws//modules/zones?version=2.5.0"
}

dependency "delegation_sets" {
  config_path = "${get_terragrunt_dir()}/../delegation-sets/"
}

inputs = {
  zones = {
    for z in local.zones : z => {
      delegation_set_id = dependency.delegation_sets.outputs.route53_delegation_set_id[z],
      tags              = { Name = z },
    }
  }

  tags = {
    Project     = local.root.name
    Environment = local.env.long
  }
}
