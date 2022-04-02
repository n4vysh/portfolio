locals {
  root = read_terragrunt_config(find_in_parent_folders()).locals
  env  = read_terragrunt_config("${dirname(find_in_parent_folders(""))}/base/env.hcl").locals.env

  aws_auth_configmap_additional_map_roles_yaml = <<EOT
    - rolearn: arn:aws:iam::804137327620:role/OrganizationAccountAccessRole
      username: system:master:{{AccountID}}:{{SessionName}}
      groups:
        - system:masters
EOT
}

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
    "../namespaces",
  ]
}

dependency "iam_irsa_albc" {
  config_path = "../../iam/irsa/aws-load-balancer-controller"

  mock_outputs = {
    iam_role_arn = "temporary-dummy-iam-role-arn"
  }
}

dependency "iam_irsa_thanos" {
  config_path = "../../iam/irsa/thanos"

  mock_outputs = {
    iam_role_arn = "temporary-dummy-iam-role-arn"
  }
}

dependency "iam_irsa_loki" {
  config_path = "../../iam/irsa/loki"

  mock_outputs = {
    iam_role_arn = "temporary-dummy-iam-role-arn"
  }
}

dependency "s3_bucket_thanos" {
  config_path = "../../storage/thanos"

  mock_outputs = {
    s3_bucket_id     = "temporary-dummy-s3-bucket-id"
    s3_bucket_region = "temporary-dummy-s3-bucket-region"
  }
}

dependency "s3_bucket_loki" {
  config_path = "../../storage/loki"

  mock_outputs = {
    s3_bucket_id     = "temporary-dummy-s3-bucket-id"
    s3_bucket_region = "temporary-dummy-s3-bucket-region"
  }
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
      name = "aws_auth"
      content = join(
        "",
        [
          dependency.cluster.outputs.aws_auth_configmap_yaml,
          local.aws_auth_configmap_additional_map_roles_yaml,
        ]
      )
    },
    {
      name = "aws_load_balancer_controller_helm_values"
      content = templatefile(
        "${get_terragrunt_dir()}/aws_load_balancer_controller/configmap.yaml.tftpl",
        {
          name      = "aws-load-balancer-controller-helm-values"
          namespace = "kube-system"
          cluster   = dependency.cluster.outputs.cluster_id
          role_arn  = dependency.iam_irsa_albc.outputs.iam_role_arn
        }
      )
    },
    {
      name = "kube_prometheus_stack_helm_values"
      content = templatefile(
        "${get_terragrunt_dir()}/kube_prometheus_stack/configmap.yaml.tftpl",
        {
          name             = "kube-prometheus-stack-helm-values"
          namespace        = "kube-prometheus-stack"
          env              = local.env.long
          cluster          = dependency.cluster.outputs.cluster_id
          s3_bucket_id     = dependency.s3_bucket_thanos.outputs.s3_bucket_id
          s3_bucket_region = dependency.s3_bucket_thanos.outputs.s3_bucket_region
          role_arn         = dependency.iam_irsa_thanos.outputs.iam_role_arn
        }
      )
    },
    {
      name = "loki_helm_values"
      content = templatefile(
        "${get_terragrunt_dir()}/loki/configmap.yaml.tftpl",
        {
          name             = "loki-helm-values"
          namespace        = "loki"
          s3_bucket_id     = dependency.s3_bucket_loki.outputs.s3_bucket_id
          s3_bucket_region = dependency.s3_bucket_loki.outputs.s3_bucket_region
          role_arn         = dependency.iam_irsa_loki.outputs.iam_role_arn
        }
      )
    },
    {
      name = "fluent_bit_helm_values"
      content = templatefile(
        "${get_terragrunt_dir()}/fluent/configmap.yaml.tftpl",
        {
          name      = "fluent-bit-helm-values"
          namespace = "fluent-bit"
          env       = local.env.long
        }
      )
    },
    {
      name = "target_group_bindings_helm_values"
      content = templatefile(
        "${get_terragrunt_dir()}/target_group_bindings/configmap.yaml.tftpl",
        {
          name              = "target-group-bindings-helm-values"
          namespace         = "contour"
          target_group_arn  = dependency.lb.outputs.target_group_arn,
          security_group_id = dependency.lb.outputs.security_group_id,
        }
      )
    },
  ]
}
