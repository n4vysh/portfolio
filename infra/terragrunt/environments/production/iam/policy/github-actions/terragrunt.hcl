include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "aws_iam_policy" {
  path = "${dirname(find_in_parent_folders(""))}/base/modules/aws-iam-policy.hcl"
}

dependencies {
  paths = ["../../../data/aws-iam-policy"]
}

dependency "data_aws_iam_policy" {
  config_path = "../../../data/aws-iam-policy"

  mock_outputs = {
    github_actions = jsonencode(
      {
        Version = "dummy-version"
      }
    )

  }
}

inputs = {
  policy = dependency.data_aws_iam_policy.outputs.github_actions
}
