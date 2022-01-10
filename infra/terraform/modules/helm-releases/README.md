<!-- BEGIN_TF_DOCS -->
<!-- markdownlint-disable-file -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1.7 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.4.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.4.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_helm"></a> [helm](#input\_helm) | helm release parameters | <pre>list(<br>    object(<br>      {<br>        name       = string<br>        repository = string<br>        chart      = string<br>        version    = string<br>        namespace  = string<br>        timeout    = number<br>        values     = list(string)<br>      }<br>    )<br>  )</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
