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
    "../../lb",
  ]
}

inputs = {
  yaml = [
    {
      name    = "contour"
      content = file("${get_terragrunt_dir()}/namespace.yaml")
    }
  ]
}
