resource "kubectl_manifest" "this" {
  for_each = { for yaml in var.yaml : yaml.name => yaml }

  yaml_body = each.value.content
}
