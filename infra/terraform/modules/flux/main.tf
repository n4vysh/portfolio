# SSH
locals {
  known_hosts = "[ssh.github.com]:443 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="
}

resource "tls_private_key" "this" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

# Flux
data "flux_install" "this" {
  target_path = var.target_path
}

data "flux_sync" "this" {
  target_path = var.target_path
  url         = "ssh://git@ssh.github.com:443/${var.github_owner}/${var.repository_name}.git"
  branch      = var.branch
}

# Kubernetes
resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

data "kubectl_file_documents" "install" {
  content = data.flux_install.this.content
}

data "kubectl_file_documents" "sync" {
  content = data.flux_sync.this.content
}

locals {
  install = [for v in data.kubectl_file_documents.install.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
  sync = [for v in data.kubectl_file_documents.sync.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
}

resource "kubectl_manifest" "install" {
  for_each   = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

resource "kubectl_manifest" "sync" {
  for_each   = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

resource "kubernetes_secret" "this" {
  depends_on = [kubectl_manifest.install]

  metadata {
    name      = data.flux_sync.this.secret
    namespace = data.flux_sync.this.namespace
  }

  data = {
    identity       = tls_private_key.this.private_key_pem
    "identity.pub" = tls_private_key.this.public_key_pem
    known_hosts    = local.known_hosts
  }
}

# GitHub
resource "github_repository_deploy_key" "this" {
  title      = "${var.env.long}-cluster"
  repository = var.repository_name
  key        = tls_private_key.this.public_key_openssh
  read_only  = true
}

resource "github_repository_file" "install" {
  repository = var.repository_name
  file       = data.flux_install.this.path
  content    = data.flux_install.this.content
  branch     = var.branch

  overwrite_on_create = true
}

resource "github_repository_file" "sync" {
  repository = var.repository_name
  file       = data.flux_sync.this.path
  content    = data.flux_sync.this.content
  branch     = var.branch

  overwrite_on_create = true
}

resource "github_repository_file" "kustomize" {
  repository = var.repository_name
  file       = data.flux_sync.this.kustomize_path
  content    = data.flux_sync.this.kustomize_content
  branch     = var.branch

  overwrite_on_create = true
}
