locals {
  dir = one(
    regex(
      "environments/[^/]+/[^/]+/[^/]+/([^/]+)",
      get_original_terragrunt_dir()
    )
  )
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "aws_iam_irsa" {
  path = "${dirname(find_in_parent_folders(""))}/base/modules/aws-iam-irsa.hcl"
}

dependency "eks" {
  config_path = "../../../cluster"

  mock_outputs = {
    oidc_provider_arn = "temporary-dummy-arn"
  }
}

dependency "policy_thanos" {
  config_path = "../../policy/thanos"

  mock_outputs = {
    arn = "dummry-arn"
  }
}

inputs = {
  role_policy_arns = [dependency.policy_thanos.outputs.arn]

  oidc_providers = {
    main = {
      provider_arn               = dependency.eks.outputs.oidc_provider_arn
      namespace_service_accounts = ["kube-prometheus-stack:${local.dir}"]
    }
  }
}
