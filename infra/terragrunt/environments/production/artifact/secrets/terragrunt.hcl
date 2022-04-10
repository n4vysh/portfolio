locals {
  # sops_decrypt_file function not read $SOPS_AGE_KEY?
  identity_trust_anchors_pem  = run_cmd("--terragrunt-quiet", "sops", "-d", "${get_terragrunt_dir()}/ca.crt")
  identity_issuer_tls_crt_pem = run_cmd("--terragrunt-quiet", "sops", "-d", "${get_terragrunt_dir()}/issuer.crt")
  identity_issuer_tls_key_pem = run_cmd("--terragrunt-quiet", "sops", "-d", "${get_terragrunt_dir()}/issuer.key")
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

inputs = {
  yaml = [
    {
      name = "linkerd_helm_values"
      content = templatefile(
        "${get_terragrunt_dir()}/linkerd/secret.yaml.tftpl",
        {
          name                        = "linkerd-helm-values"
          namespace                   = "linkerd"
          identity_trust_anchors_pem  = local.identity_trust_anchors_pem
          identity_issuer_tls_crt_pem = local.identity_issuer_tls_crt_pem
          identity_issuer_tls_key_pem = local.identity_issuer_tls_key_pem
        }
      )
    },
  ]
}
