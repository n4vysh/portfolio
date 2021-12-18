provider "grafana" {
  url = "https://n4vysh.grafana.net"
}

resource "grafana_dashboard" "main" {
  for_each    = toset(var.dashboards)
  config_json = file("${path.root}/${each.key}")
}
