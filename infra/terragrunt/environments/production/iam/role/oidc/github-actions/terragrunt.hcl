locals {
  root = read_terragrunt_config(find_in_parent_folders()).locals
}
include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "aws_iam_oidc" {
  path = "${dirname(find_in_parent_folders(""))}/base/modules/aws-iam-oidc.hcl"
}

dependency "policy_github_actions" {
  config_path = "../../../policy/github-actions"

  mock_outputs = {
    arn = "dummry-arn"
  }
}

inputs = {
  provider_url = "token.actions.githubusercontent.com"

  oidc_subjects_with_wildcards = [
    "repo:${local.root.user}/${local.root.name}:*"
  ]

  role_policy_arns = [dependency.policy_github_actions.outputs.arn]
}
