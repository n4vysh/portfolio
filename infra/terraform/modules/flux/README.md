<!-- BEGIN_TF_DOCS -->
<!-- markdownlint-disable-file -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1.7 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | >= 0.0.13 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 4.5.2 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.10.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.2 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_flux"></a> [flux](#provider\_flux) | >= 0.0.13 |
| <a name="provider_github"></a> [github](#provider\_github) | >= 4.5.2 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 1.10.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.0.2 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_repository_deploy_key.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_deploy_key) | resource |
| [github_repository_file.install](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.kustomize](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.sync](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [kubectl_manifest.install](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.sync](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.flux_system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) | resource |
| [flux_install.this](https://registry.terraform.io/providers/fluxcd/flux/latest/docs/data-sources/install) | data source |
| [flux_sync.this](https://registry.terraform.io/providers/fluxcd/flux/latest/docs/data-sources/sync) | data source |
| [kubectl_file_documents.install](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/data-sources/file_documents) | data source |
| [kubectl_file_documents.sync](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/data-sources/file_documents) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_branch"></a> [branch](#input\_branch) | branch name | `string` | `"main"` | no |
| <a name="input_env"></a> [env](#input\_env) | The environment name | <pre>object({<br>    short = string<br>    long  = string<br>  })</pre> | n/a | yes |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | github owner | `string` | n/a | yes |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | github repository name | `string` | n/a | yes |
| <a name="input_target_path"></a> [target\_path](#input\_target\_path) | flux sync target path | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
