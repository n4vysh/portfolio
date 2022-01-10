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
    "../../iam/irsa/aws-load-balancer-controller",
    "../kube-prometheus-stack",
    "../thanos",
  ]
}

dependency "iam_irsa_albc" {
  config_path = "../../iam/irsa/aws-load-balancer-controller"

  mock_outputs = {
    iam_role_arn = "temporary-dummy-iam-role-arn"
  }
}

inputs = {
  helm = [
    {
      name       = "aws-load-balancer-controller"
      repository = "https://aws.github.io/eks-charts"
      chart      = "aws-load-balancer-controller"
      version    = "1.4.0"
      namespace  = "kube-system"

      timeout = 300

      values = [
        yamlencode(
          {
            clusterName = dependency.cluster.outputs.cluster_id
            serviceAccount = {
              create = true
              name   = "aws-load-balancer-controller"
              annotations = {
                "eks.amazonaws.com/role-arn" = dependency.iam_irsa_albc.outputs.iam_role_arn
              }
            }
            serviceMonitor = {
              enabled = true
            }
          }
        )
      ]
    },
  ]
}
