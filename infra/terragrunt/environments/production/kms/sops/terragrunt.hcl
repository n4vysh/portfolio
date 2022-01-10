prevent_destroy = true

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "aws_kms_keys" {
  path = "${dirname(find_in_parent_folders(""))}/base/modules/aws-kms-keys.hcl"
}
