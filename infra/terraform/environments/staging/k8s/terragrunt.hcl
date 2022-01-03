include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules//civo/k8s"
}

inputs = {
  name = "portfolio"
  env  = "staging"

  kubernetes = {
    count   = 1
    size    = "medium"
    version = "1.20.0-k3s1"
  }
}
