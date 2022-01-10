include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "aws_s3_bucket" {
  path = "${dirname(find_in_parent_folders(""))}/base/modules/aws-s3-bucket.hcl"
}
