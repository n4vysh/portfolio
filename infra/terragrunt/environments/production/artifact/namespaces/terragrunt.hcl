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
      name = "kube_prometheus_stack"
      content = templatefile(
        "${get_terragrunt_dir()}/common/namespace.yaml.tftpl",
        {
          namespace = "kube-prometheus-stack"
        }
      )
    },
    {
      name = "loki"
      content = templatefile(
        "${get_terragrunt_dir()}/common/namespace.yaml.tftpl",
        {
          namespace = "loki"
        }
      )
    },
    {
      name = "fluent_bit"
      content = templatefile(
        "${get_terragrunt_dir()}/common/namespace.yaml.tftpl",
        {
          namespace = "fluent-bit"
        }
      )
    },
    {
      name = "tempo"
      content = templatefile(
        "${get_terragrunt_dir()}/common/namespace.yaml.tftpl",
        {
          namespace = "tempo"
        }
      )
    },
    {
      name = "istio_system"
      content = templatefile(
        "${get_terragrunt_dir()}/common/namespace.yaml.tftpl",
        {
          namespace = "istio-system"
        }
      )
    },
  ]
}
