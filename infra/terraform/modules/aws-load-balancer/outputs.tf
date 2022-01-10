output "target_group_arn" {
  description = "Amazon Resource Names of AWS LB Target Group"
  value       = aws_lb_target_group.http.arn
}

output "security_group_id" {
  description = "ID of AWS LB Security Group"
  value       = aws_security_group.alb.id
}
