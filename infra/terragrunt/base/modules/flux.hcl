locals {
  root = read_terragrunt_config(find_in_parent_folders()).locals

  providers = read_terragrunt_config(
    find_in_parent_folders("base/providers/generate.hcl")
  )
}

generate = {
  aws_provider              = local.providers.generate["aws_provider"]
  cluster_variables         = local.providers.generate["cluster_variables"]
  aws_eks_cluster_auth_data = local.providers.generate["aws_eks_cluster_auth_data"]
  kubernetes_provider       = local.providers.generate["kubernetes_provider"]
  kubectl_provider          = local.providers.generate["kubectl_provider"]
  flux_provider             = local.providers.generate["flux_provider"]
  github_provider           = local.providers.generate["github_provider"]
}

terraform {
  source = "${dirname(find_in_parent_folders())}/../terraform/modules//flux"
}

dependency "cluster" {
  config_path = "../cluster"

  mock_outputs = {
    cluster_endpoint                   = "temporary-dummy-cluster-endpoint"
    cluster_certificate_authority_data = "temporary-dummy-cluster-ca-cert"
    cluster_id                         = "temporary-dummy-cluster-id"
  }
}

inputs = {
  cluster_endpoint = dependency.cluster.outputs.cluster_endpoint
  cluster_ca_cert  = dependency.cluster.outputs.cluster_certificate_authority_data
  cluster_id       = dependency.cluster.outputs.cluster_id

  github_owner    = local.root.user
  repository_name = local.root.name
}
