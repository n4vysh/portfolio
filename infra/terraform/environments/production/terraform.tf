terraform {
  required_providers {
    civo = {
      source  = "civo/civo"
      version = ">= 1.0.5"
    }
  }

  backend "s3" {}

  required_version = ">= 1.0.5"
}
