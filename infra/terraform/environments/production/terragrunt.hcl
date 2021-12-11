include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//k8s"
}

inputs = {
  env = "production"
  node = 2
}
