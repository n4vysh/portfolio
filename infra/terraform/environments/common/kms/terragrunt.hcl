include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules//kms"
}

inputs = {
  name = "helmfile"
}
