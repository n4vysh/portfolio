terraform {
  required_providers {
    civo = {
      source  = "civo/civo"
      version = ">= 1.0.5"
    }
  }

  required_version = ">= 1.0.5"
}

provider "civo" {
  region = "NYC1"
}

data "civo_instances_size" "main" {
  filter {
    key      = "name"
    values   = ["g3.k3s.${var.kubernetes.size}"]
    match_by = "re"
  }

  filter {
    key    = "type"
    values = ["kubernetes"]
  }
}

resource "civo_firewall" "main" {
  name = "${var.name}-${var.env}"
}

locals {
  firewalls = {
    http = {
      port = "80",
    },
    https = {
      port = "443",
    },
    kubernetes_api_server = {
      port = "6443",
    },
  }
}

resource "civo_firewall_rule" "main" {
  for_each = local.firewalls

  firewall_id = civo_firewall.main.id
  protocol    = "tcp"
  start_port  = each.value.port
  end_port    = each.value.port
  cidr        = ["0.0.0.0/0"]
  direction   = "ingress"
  label       = each.key
}

resource "civo_kubernetes_cluster" "main" {
  name               = "${var.name}-${var.env}"
  applications       = "-Traefik,-metrics-server"
  num_target_nodes   = var.kubernetes.count
  kubernetes_version = var.kubernetes.version
  target_nodes_size  = element(data.civo_instances_size.main.sizes, 0).name
  firewall_id        = civo_firewall.main.id
}

output "kubeconfig" {
  value     = civo_kubernetes_cluster.main.kubeconfig
  sensitive = true
}
