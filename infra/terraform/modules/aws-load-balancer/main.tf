locals {
  name = "${var.env.short}-${var.project}"
}

resource "aws_lb" "alb" {
  name               = local.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.subnet_ids

  drop_invalid_header_fields = true

  enable_deletion_protection = true

  access_logs {
    bucket  = var.bucket_id.lb
    enabled = true
  }

  tags = {
    Project     = var.project
    Name        = local.name
    Environment = var.env.long
  }
}

resource "aws_security_group" "alb" {
  name        = local.name
  description = "Allow outbound traffic"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow all port and protocol"

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project     = var.project
    Name        = local.name
    Environment = var.env.long
  }
}

resource "aws_security_group_rule" "https" {
  #ts:skip=AC_AWS_0229 distribute content with https

  security_group_id = aws_security_group.alb.id

  description = "Allow https"

  type = "ingress"

  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_acm_certificate" "alb" {
  domain_name       = var.domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "this" {
  name         = var.domain
  private_zone = false
}

resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.alb.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this.zone_id
}

resource "aws_acm_certificate_validation" "alb" {
  certificate_arn         = aws_acm_certificate.alb.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"

  certificate_arn = aws_acm_certificate_validation.alb.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

resource "aws_lb_target_group" "http" {
  #ts:skip=AC_AWS_0492 use kubernetes pod IP with aws-load-balancer-controller instead of DNS record

  name     = local.name
  port     = 80
  protocol = "HTTP"

  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_wafv2_web_acl" "basic" {
  # checkov:skip=CKV2_AWS_31:false positive?

  name  = "${local.name}-basic"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "rate-limit"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 100
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.name}-rate-limit-rule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "managed-common"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.name}-managed-common-rule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "managed-known-bad-inputs"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.name}-managed-known-bad-inputs-rule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "managed-linux"
    priority = 4

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.name}-managed-linux-rule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "managed-unix"
    priority = 5

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesUnixRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.name}-managed-unix-rule"
      sampled_requests_enabled   = true
    }
  }

  tags = {
    Project     = var.project
    Name        = local.name
    Environment = var.env.long
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${local.name}-basic-web-acl"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "this" {
  resource_arn = aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.basic.arn
}

resource "aws_route53_record" "alb" {
  name    = var.domain
  zone_id = data.aws_route53_zone.this.zone_id
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}
