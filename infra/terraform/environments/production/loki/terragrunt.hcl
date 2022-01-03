include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules//aws/s3"
}

inputs = {
  env = {
    short = "prd"
    full  = "production"
  }
  name   = "loki"
  domain = "n4vysh.dev"

  policy_actions = [
    "s3:ListBucket",
    "s3:GetObject",
    "s3:DeleteObject",
    "s3:PutObject"
  ]
}
