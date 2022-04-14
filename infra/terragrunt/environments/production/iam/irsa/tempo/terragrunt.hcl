include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "aws_iam_irsa" {
  path = "${dirname(find_in_parent_folders(""))}/base/modules/aws-iam-irsa.hcl"
}

dependency "policy_tempo" {
  config_path = "../../policy/tempo"

  mock_outputs = {
    arn = "dummry-arn"
  }
}

inputs = {
  role_policy_arns = [dependency.policy_tempo.outputs.arn]
}
