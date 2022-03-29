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
    "../contour",
  ]
}

dependency "lb" {
  config_path = "../../lb"

  mock_outputs = {
    target_group_arn  = "temporary-dummy-target-group-arn"
    security_group_id = "temporary-dummy-security-group-id"
  }
}

inputs = {
  yaml = [
    {
      name = "target-group-bindings"
      content = templatefile(
        "${get_terragrunt_dir()}/configmap.yaml.tftpl",
        {
          target_group_arn  = dependency.lb.outputs.target_group_arn,
          security_group_id = dependency.lb.outputs.security_group_id,
        }
      )
    }
  ]
}
