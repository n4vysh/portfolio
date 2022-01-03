include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules//civo/k8s"
}

inputs = {
  name = "portfolio"
  env  = "production"

  kubernetes = {
    count   = 2
    size    = "small"
    version = "1.20.0-k3s1"
  }
}
