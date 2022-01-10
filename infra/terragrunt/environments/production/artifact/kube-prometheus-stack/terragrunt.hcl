locals {
  root = read_terragrunt_config(find_in_parent_folders()).locals
  env  = read_terragrunt_config("${dirname(find_in_parent_folders(""))}/base/env.hcl").locals.env

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
  ]
}

dependency "iam_irsa_thanos" {
  config_path = "../../iam/irsa/thanos"

  mock_outputs = {
    iam_role_arn = "temporary-dummy-iam-role-arn"
  }
}

inputs = {
  helm = [
    {
      name       = local.name
      repository = "https://prometheus-community.github.io/helm-charts"
      chart      = local.name
      version    = "23.3.2"
      namespace  = local.name

      timeout = 300

      values = [
        yamlencode(
          {
            alertmanager = {
              enabled = false
            }
            prometheus = {
              serviceAccount = {
                create = true
                name   = "thanos"
                annotations = {
                  "eks.amazonaws.com/role-arn" = dependency.iam_irsa_thanos.outputs.iam_role_arn
                }
              }
              thanosService = {
                enabled = true
              }
              thanosServiceMonitor = {
                enabled = true
              }
              prometheusSpec = {
                thanos = {
                  image = "quay.io/thanos/thanos:v0.23.1"
                  objectStorageConfig = {
                    name = "thanos-secret"
                    key  = "objstore.yml"
                  }
                }
                scrapeInterval                          = "1m"
                serviceMonitorSelectorNilUsesHelmValues = false
                replicaExternalLabelName                = "__replica__"
                externalLabels = {
                  env     = local.env.long
                  cluster = "${local.env.short}-${local.root.name}"
                }
              }
              extraSecret = {
                name = "thanos-secret"
                data = {
                  "objstore.yml" = <<-EOF
                    type: s3
                    config:
                      bucket: "${local.env.short}-${local.root.user}-thanos"
                      endpoint: s3-accesspoint.dualstack.ap-northeast-1.amazonaws.com
                      region: ap-northeast-1
                    EOF
                }
              }
            }
            grafana = {
              enabled = true
              "grafana.ini" = {
                server = {
                  enable_gzip = true
                }
                security = {
                  disable_gravatar = true
                }
              }
              datasources = {
                "datasources.yaml" = {
                  apiVersion = 1
                  datasources = [
                    {
                      name   = "Prometheus"
                      type   = "prometheus"
                      access = "proxy"
                      url    = "http://thanos-query.kube-prometheus-stack.svc.cluster.local:9090"
                      version : 1
                      editable : false
                    },
                    {
                      name     = "Loki"
                      type     = "loki"
                      access   = "proxy"
                      url      = "http://loki.loki:3100"
                      version  = 1
                      editable = false
                    },
                  ]
                }
              }
              dashboardProviders = {
                "dashboardproviders.yaml" = {
                  apiVersion = 1
                  providers = [
                    {
                      name            = "default"
                      orgId           = 1
                      folder          = ""
                      type            = "file"
                      disableDeletion = true
                      editable        = false
                      options = {
                        path = "/var/lib/grafana/dashboards/default"
                      }
                    }
                  ]
                }
              }
              dashboards = {
                default = {
                  nginx = {
                    url = "https://raw.githubusercontent.com/nginxinc/nginx-prometheus-exporter/v0.10.0/grafana/dashboard.json"
                  }
                }
              }
            }
          }
        )
      ]
    },
  ]
}
