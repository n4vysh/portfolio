include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules//aws/kms"
}

inputs = {
  name = "portfolio/sops"
  env  = "common"
}
