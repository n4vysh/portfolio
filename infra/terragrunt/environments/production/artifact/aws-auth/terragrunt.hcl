locals {
  aws_auth = <<EOT
    - rolearn: arn:aws:iam::804137327620:role/OrganizationAccountAccessRole
      username: system:master:{{AccountID}}:{{SessionName}}
      groups:
        - system:masters
EOT
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "kubectl_manifests" {
  path = "${dirname(find_in_parent_folders(""))}/base/modules/kubectl-manifests.hcl"
}

dependencies {
  paths = [
    "../../cluster",
  ]
}

inputs = {
  yaml = [
    {
      name    = "aws-auth"
      content = "${dependency.cluster.outputs.aws_auth_configmap_yaml}${local.aws_auth}"
    }
  ]
}
