include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "flux" {
  path = "${dirname(find_in_parent_folders(""))}/base/modules/flux.hcl"
}

dependencies {
  paths = [
    "../artifact/configmaps",
  ]
}

inputs = {
  branch      = "main"
  target_path = "infra/flux/clusters/production/"
}
