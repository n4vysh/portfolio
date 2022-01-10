skip                          = true
terraform_version_constraint  = "~> 1.1.7"
terragrunt_version_constraint = "~> 0.36.3"

locals {
  name   = "portfolio"
  user   = "n4vysh"
  tld    = "dev"
  domain = "${local.user}.${local.tld}"
}

terraform {
  before_hook "terraform_validate" {
    commands = ["plan"]
    execute = [
      "terraform",
      "validate",
    ]
  }

  before_hook "terraform_fmt" {
    commands = ["plan"]
    execute = [
      "terraform",
      "fmt",
      "-diff",
      "-check",
    ]
  }

  extra_arguments "plan_out" {
    commands = [
      "plan",
    ]

    arguments = [
      "-out",
      "tfplan.binary",
    ]
  }

  after_hook "convert_from_bin_to_json" {
    commands = ["plan"]
    execute = [
      "sh",
      "-c",
      join(
        " ",
        [
          "terraform",
          "show",
          "-json",
          "tfplan.binary",
          ">",
          "tfplan.json",
        ]
      )
    ]
  }

  after_hook "infracost" {
    commands = ["plan"]
    execute = [
      "infracost",
      "diff",
      "--path",
      "tfplan.json",
    ]
  }

  after_hook "conftest" {
    commands = ["plan"]
    execute = [
      "conftest",
      "test",
      "--policy",
      "${get_parent_terragrunt_dir()}/policy/main.rego",
      "tfplan.json",
    ]
  }

  after_hook "rm_tfplan" {
    commands = ["plan"]
    execute = [
      "rm",
      "tfplan.binary",
      "tfplan.json",
    ]
  }
}

inputs = {
  project = local.name
}
