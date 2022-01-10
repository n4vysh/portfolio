locals {
  env = read_terragrunt_config("${dirname(find_in_parent_folders(""))}/base/env.hcl").locals.env

  name = one(
    regex(
      "environments/[^/]+/[^/]+/([^/]+)",
      get_original_terragrunt_dir()
    )
  )
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "helm_releases" {
  path = "${dirname(find_in_parent_folders(""))}/base/modules/helm-releases.hcl"
}

dependencies {
  paths = [
    "../../cluster",
    "../kube-prometheus-stack",
    "../thanos",
    "../loki",
  ]
}

inputs = {
  helm = [
    {
      name       = local.name
      repository = "https://fluent.github.io/helm-charts"
      chart      = local.name
      version    = "0.19.15"
      namespace  = local.name

      timeout = 300

      values = [
        yamlencode(
          {
            serviceMonitor = {
              enabled = true
            }
            config = {
              outputs = <<-EOF
                [OUTPUT]
                    name                   loki
                    match                  *
                    labels                 job=fluentbit,env=${local.env.long}
                    auto_kubernetes_labels on

                    host loki.loki
              EOF
            }
            dashboards = {
              enabled   = true
              namespace = "kube-prometheus-stack"
            }
          }
        )
      ]
    },
  ]
}
