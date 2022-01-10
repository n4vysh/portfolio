locals {
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
  ]
}

inputs = {
  helm = [
    {
      name       = local.name
      repository = "https://charts.bitnami.com/bitnami"
      chart      = local.name
      version    = "8.2.5"
      namespace  = "kube-prometheus-stack"

      timeout = 300

      values = [
        yamlencode(
          {
            # NOTE: use serviceaccount of prometheus operator
            existingServiceAccount = "thanos"
            # NOTE: use extraSecret of prometheus operator
            existingObjstoreSecret = "thanos-secret"
            query = {
              # NOTE: use replicaExternalLabelName of prometheus operator
              replicaLabel = "__replica__"
              dnsDiscovery = {
                sidecarsService   = "kube-prometheus-stack-thanos-discovery"
                sidecarsNamespace = "kube-prometheus-stack"
              }
            }
            bucketweb = {
              enabled = true
            }
            storegateway = {
              enabled = true
            }
            compactor = {
              enabled                = true
              retentionResolution1h  = "24h"
              retentionResolution5m  = "24h"
              retentionResolutionRaw = "24h"
            }
            metrics = {
              enabled = true
              serviceMonitor = {
                enabled = true
              }
            }
          }
        )
      ]
    },
  ]
}
