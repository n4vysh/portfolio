provider "kubectl" {
  host                   = var.cluster_id == "temporary-dummy-cluster-id" ? null : var.cluster_endpoint
  cluster_ca_certificate = var.cluster_id == "temporary-dummy-cluster-id" ? null : base64decode(var.cluster_ca_cert)
  token                  = var.cluster_id == "temporary-dummy-cluster-id" ? null : data.aws_eks_cluster_auth.this.token
  config_path            = var.cluster_id == "temporary-dummy-cluster-id" ? "/tmp/kubeconfig" : null
  load_config_file       = var.cluster_id == "temporary-dummy-cluster-id" ? true : false
}
