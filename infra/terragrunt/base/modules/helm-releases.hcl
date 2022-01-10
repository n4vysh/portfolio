locals {
  providers = read_terragrunt_config(
    find_in_parent_folders("base/providers/generate.hcl")
  )
}

generate = {
  aws_provider              = local.providers.generate["aws_provider"]
  cluster_variables         = local.providers.generate["cluster_variables"]
  aws_eks_cluster_auth_data = local.providers.generate["aws_eks_cluster_auth_data"]
  helm_provider             = local.providers.generate["helm_provider"]
}

terraform {
  source = "${dirname(find_in_parent_folders())}/../terraform/modules//helm-releases"
}

dependency "cluster" {
  config_path = "../../cluster"

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
}
