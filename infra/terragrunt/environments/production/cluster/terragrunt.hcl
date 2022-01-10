include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "aws_eks_cluster" {
  path = "${dirname(find_in_parent_folders(""))}/base/modules/aws-eks-cluster.hcl"
}

dependencies {
  paths = ["../vpc"]
}
