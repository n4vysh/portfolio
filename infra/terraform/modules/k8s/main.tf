provider "civo" {
  region = "NYC1"
}

data "civo_instances_size" "xsmall" {
  filter {
    key    = "type"
    values = ["kubernetes"]
  }

  sort {
    key       = "ram"
    direction = "asc"
  }
}

resource "civo_firewall" "portfolio" {
  name = "portfolio-${var.env}"
}

resource "civo_firewall_rule" "http" {
  firewall_id = civo_firewall.portfolio.id
  protocol    = "tcp"
  start_port  = "80"
  end_port    = "80"
  cidr        = ["0.0.0.0/0"]
  direction   = "ingress"
  label       = "website-http"
}

resource "civo_firewall_rule" "https" {
  firewall_id = civo_firewall.portfolio.id
  protocol    = "tcp"
  start_port  = "443"
  end_port    = "443"
  cidr        = ["0.0.0.0/0"]
  direction   = "ingress"
  label       = "website-https"
}

resource "civo_firewall_rule" "kubernetes" {
  firewall_id = civo_firewall.portfolio.id
  protocol    = "tcp"
  start_port  = "6443"
  end_port    = "6443"
  cidr        = ["0.0.0.0/0"]
  direction   = "ingress"
  label       = "kubernetes-api-server"
}

resource "civo_kubernetes_cluster" "portfolio" {
  name               = "portfolio-${var.env}"
  applications       = "-Traefik,-metrics-server"
  num_target_nodes   = var.node
  kubernetes_version = "1.20.0-k3s1"
  target_nodes_size  = element(data.civo_instances_size.xsmall.sizes, 0).name
  firewall_id        = civo_firewall.portfolio.id
}
