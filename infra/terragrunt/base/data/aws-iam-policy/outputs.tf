output "thanos" {
  value = data.aws_iam_policy_document.thanos.json
}

output "loki" {
  value = data.aws_iam_policy_document.loki.json
}

output "github_actions" {
  value = data.aws_iam_policy_document.github_actions.json
}
