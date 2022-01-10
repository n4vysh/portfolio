include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${dirname(find_in_parent_folders(""))}/base/env.hcl"
}

include "aws_load_balancer" {
  path = "${dirname(find_in_parent_folders(""))}/base/modules/aws-load-balancer.hcl"
}

dependencies {
  paths = [
    "../vpc",         # for security group and target group
    "../dns/zones",   # for ACM DNS validation
    "../storage/alb", # for ALB access logs
  ]
}

inputs = {
  region = "ap-northeast-1"
}
