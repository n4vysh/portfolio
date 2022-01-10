include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "aws_iam_irsa" {
  path = "${dirname(find_in_parent_folders(""))}/base/modules/aws-iam-irsa.hcl"
}

dependencies {
  paths = ["../../../cluster"]
}

inputs = {
  attach_load_balancer_controller_policy = true
}
