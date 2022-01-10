resource "helm_release" "this" {
  for_each = { for helm in var.helm : helm.name => helm }

  name       = each.value.name
  repository = each.value.repository
  chart      = each.value.chart
  version    = each.value.version
  namespace  = each.value.namespace
  timeout    = each.value.timeout

  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  create_namespace = true

  values = each.value.values
}
