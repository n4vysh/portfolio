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
    "../kube-prometheus-stack",
    "../thanos",
  ]
}

dependency "iam_irsa_loki" {
  config_path = "../../iam/irsa/loki"

  mock_outputs = {
    iam_role_arn = "temporary-dummy-iam-role-arn"
  }
}

inputs = {
  helm = [
    {
      name       = local.name
      repository = "https://grafana.github.io/helm-charts"
      chart      = local.name
      version    = "2.8.4"
      namespace  = local.name

      timeout = 300

      values = [
        yamlencode(
          {
            serviceMonitor = {
              enabled = true
            }
            serviceAccount = {
              name = "loki"
              annotations = {
                "eks.amazonaws.com/role-arn" = dependency.iam_irsa_loki.outputs.iam_role_arn
              }
            }
            config = {
              compactor = {
                shared_store                  = "s3"
                compaction_interval           = "10m"
                retention_enabled             = true
                retention_delete_delay        = "2h"
                retention_delete_worker_count = 150
              }
              limits_config = {
                # NOTE: The minimum retention period is 24h.
                # https://grafana.com/docs/loki/latest/operations/storage/retention/
                retention_period = "24h"
              }
              schema_config = {
                configs = [
                  {
                    from         = "2020-10-24"
                    store        = "boltdb-shipper"
                    object_store = "s3"
                    schema       = "v11"
                    index = {
                      prefix = "index_"
                      period = "24h"
                    }
                  }
                ]
              }
              storage_config = {
                boltdb_shipper = {
                  shared_store = "s3"
                }
                aws = {
                  s3               = "s3://ap-northeast-1/${local.env.short}-${local.root.user}-loki"
                  s3forcepathstyle = true
                }
              }
            }
          }
        )
      ]
    },
  ]
}
