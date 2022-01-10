include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "data_aws_az" {
  path = "${dirname(find_in_parent_folders(""))}/base/data/aws-az/terragrunt.hcl"
}
