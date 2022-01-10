locals {
  project = read_terragrunt_config(find_in_parent_folders()).locals.name
  env = read_terragrunt_config(
    find_in_parent_folders("base/env.hcl")
  ).locals.env

  dir = one(
    regex(
      "environments/[^/]+/[^/]+/[^/]+/([^/]+)",
      get_original_terragrunt_dir()
    )
  )

  name = "${local.env.short}-${local.project}-${local.dir}"

  namespace = local.dir == "aws-load-balancer-controller" ? "kube-system" : local.dir

  providers = read_terragrunt_config(
    find_in_parent_folders("base/providers/generate.hcl")
  )
}

generate = {
  aws_provider = local.providers.generate["aws_provider"]
}

terraform {
  source = "tfr:///terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks?version=4.13.2"
}

dependency "eks" {
  config_path = "../../../cluster"

  mock_outputs = {
    oidc_provider_arn = "temporary-dummy-arn"
  }
}

inputs = {
  role_name = local.name

  oidc_providers = {
    main = {
      provider_arn               = dependency.eks.outputs.oidc_provider_arn
      namespace_service_accounts = ["${local.namespace}:${local.dir}"]
    }
  }

  tags = {
    Project     = local.project
    Name        = local.name
    Environment = local.env.long
  }
}
