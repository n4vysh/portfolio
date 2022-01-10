prevent_destroy = true

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "aws_route53_zones" {
  path = "${dirname(find_in_parent_folders(""))}/base/modules/aws-route53-zones.hcl"
}
