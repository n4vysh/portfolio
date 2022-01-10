prevent_destroy = true

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "aws_route53_delegation_sets" {
  path = "${dirname(find_in_parent_folders(""))}/base/modules/aws-route53-delegation-sets.hcl"
}
