include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "aws_iam_idp" {
  path = "${dirname(find_in_parent_folders(""))}/base/modules/aws-iam-idp.hcl"
}

inputs = {
  provider_url = "token.actions.githubusercontent.com"
}
