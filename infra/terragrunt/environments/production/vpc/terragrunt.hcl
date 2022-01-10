include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "aws_vpc" {
  path = "${dirname(find_in_parent_folders(""))}/base/modules/aws-vpc.hcl"
}

dependencies {
  paths = ["../data/aws-az"]
}
