locals {
  root = read_terragrunt_config(find_in_parent_folders()).locals

  region = "ap-northeast-1"

  dir = {
    root = dirname(find_in_parent_folders())
    env  = one(regex("environments/([a-z]+)", get_original_terragrunt_dir()))
  }

  path = replace(path_relative_to_include(), "/..\\/environments\\/[\\w]+\\//", "")

  script = "${local.dir.root}/../../scripts/get-env.bash"
  cmd    = "ENV=${local.dir.env} ${local.script} --short"

  env = {
    long  = local.dir.env
    short = run_cmd("--terragrunt-quiet", "sh", "-c", "${local.cmd}")
  }
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "${local.env.short}-${local.root.user}-tfstate"
    key            = "${local.path}/terraform.tfstate"
    region         = local.region
    encrypt        = true
    dynamodb_table = "${local.env.short}-${local.root.user}-tfstate-lock"
  }
}

inputs = {
  env = local.env
}
