include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//k8s"
}

inputs = {
  env = "staging"
  node = 1
  size = "small"
}
