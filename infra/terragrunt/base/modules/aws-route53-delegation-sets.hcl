locals {
  root = read_terragrunt_config(find_in_parent_folders()).locals
  env  = read_terragrunt_config("${dirname(find_in_parent_folders(""))}/base/env.hcl").locals.env

  sets = compact(
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
  source = "tfr:///terraform-aws-modules/route53/aws//modules/delegation-sets?version=2.5.0"
}

inputs = {
  delegation_sets = {
    for s in local.sets : s => { reference_name = s }
  }
}
