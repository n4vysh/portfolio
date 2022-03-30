locals {
  root = read_terragrunt_config(find_in_parent_folders()).locals
  env  = read_terragrunt_config("${dirname(find_in_parent_folders(""))}/base/env.hcl").locals.env
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "aws_route53_records" {
  path = "${dirname(find_in_parent_folders(""))}/base/modules/aws-route53-records.hcl"
}

dependency "delegation_sets" {
  config_path = "${get_terragrunt_dir()}/../../delegation-sets/"
}

inputs = {
  records = [
    {
      name = ""
      type = "MX"
      ttl  = 3600
      records = [
        "5 gmr-smtp-in.l.google.com",
        "10 alt1.gmr-smtp-in.l.google.com",
        "20 alt2.gmr-smtp-in.l.google.com",
        "30 alt3.gmr-smtp-in.l.google.com",
        "40 alt4.gmr-smtp-in.l.google.com",
      ]
    },
    {
      name = ""
      type = "TXT"
      ttl  = 3600
      records = [
        "keybase-site-verification=5SuI24_yjjuEK2_wZN1Wl9j1I49OqY43Ylh4QYGShDk",
      ]
    },
    {
      name    = local.env.short
      type    = "NS"
      ttl     = 3600
      records = dependency.delegation_sets.outputs.route53_delegation_set_name_servers["${local.env.short}.${local.root.domain}"]
    },
  ]
}
