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
      name = "contour"
      content = templatefile(
        "${get_terragrunt_dir()}/namespace.yaml.tftpl",
        {
          namespace = "contour"
        }
      )
    },
    {
      name = "kube_prometheus_stack"
      content = templatefile(
        "${get_terragrunt_dir()}/namespace.yaml.tftpl",
        {
          namespace = "kube-prometheus-stack"
        }
      )
    },
    {
      name = "loki"
      content = templatefile(
        "${get_terragrunt_dir()}/namespace.yaml.tftpl",
        {
          namespace = "loki"
        }
      )
    },
    {
      name = "fluent_bit"
      content = templatefile(
        "${get_terragrunt_dir()}/namespace.yaml.tftpl",
        {
          namespace = "fluent-bit"
        }
      )
    },
  ]
}
