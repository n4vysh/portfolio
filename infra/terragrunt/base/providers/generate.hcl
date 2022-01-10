generate "aws_provider" {
  path      = "aws.provider.tf"
  if_exists = "overwrite"
  contents  = file("aws.tf")
}

generate "cluster_variables" {
  path      = "cluster.variables.tf"
  if_exists = "overwrite"
  contents  = file("variables/cluster.tf")
}

generate "aws_eks_cluster_auth_data" {
  path      = "aws_eks_cluster_auth.data.tf"
  if_exists = "overwrite"
  contents  = file("data/aws_eks_cluster_auth.tf")
}

generate "kubernetes_provider" {
  path      = "kubernetes.provider.tf"
  if_exists = "overwrite"
  contents  = file("kubernetes.tf")
}

generate "helm_provider" {
  path      = "helm.provider.tf"
  if_exists = "overwrite"
  contents  = file("helm.tf")
}

generate "kubectl_provider" {
  path      = "kubectl.provider.tf"
  if_exists = "overwrite"
  contents  = file("kubectl.tf")
}

generate "flux_provider" {
  path      = "flux.provider.tf"
  if_exists = "overwrite"
  contents  = file("flux.tf")
}

generate "github_provider" {
  path      = "github.provider.tf"
  if_exists = "overwrite"
  contents  = file("github.tf")
}
