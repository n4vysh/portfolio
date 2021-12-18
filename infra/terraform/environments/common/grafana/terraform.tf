terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "1.16.0"
    }
  }

  backend "s3" {}

  required_version = ">= 1.0.5"
}
