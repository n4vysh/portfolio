remote_state {
  backend = "s3"
  config = {
    bucket  = "tfstate.n4vysh.dev"
    key     = "portfolio/${path_relative_to_include()}/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}
