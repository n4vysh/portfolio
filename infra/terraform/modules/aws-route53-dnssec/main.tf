resource "aws_kms_key" "this" {
  # checkov:skip=CKV_AWS_33:
  #ts:skip=AC_AWS_0160 for cost reduction
  # If you enable automatic key rotation, each newly generated backing key costs an additional $1/month.
  # https://aws.amazon.com/kms/pricing/?nc1=h_ls

  # The customer managed key that you use with DNSSEC signing must be in the US East (N. Virginia) Region.
  # https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec-cmk-requirements.html
  provider = aws.secondary

  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days  = 7
  key_usage                = "SIGN_VERIFY"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "kms:DescribeKey",
          "kms:GetPublicKey",
          "kms:Sign",
        ],
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Sid      = "Allow Route 53 DNSSEC Service",
        Resource = "*"
      },
      {
        Action = "kms:CreateGrant",
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Sid      = "Allow Route 53 DNSSEC Service to CreateGrant",
        Resource = "*"
        Condition = {
          Bool = {
            "kms:GrantIsForAWSResource" = "true"
          }
        }
      },
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Resource = "*"
        Sid      = "IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })

  tags = {
    Project     = var.project
    Name        = var.name
    Environment = var.env.long
  }
}

resource "aws_kms_alias" "this" {
  # The customer managed key that you use with DNSSEC signing must be in the US East (N. Virginia) Region.
  # https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-configuring-dnssec-cmk-requirements.html
  provider = aws.secondary

  name          = "alias/${var.project}/dnssec-${replace(var.name, ".", "-")}/${var.env.short}"
  target_key_id = aws_kms_key.this.key_id
}

data "aws_route53_zone" "this" {
  name = "${var.name}."
}

resource "aws_route53_key_signing_key" "this" {
  name                       = var.name
  hosted_zone_id             = data.aws_route53_zone.this.zone_id
  key_management_service_arn = aws_kms_key.this.arn
}

resource "aws_route53_hosted_zone_dnssec" "this" {
  depends_on     = [aws_route53_key_signing_key.this]
  hosted_zone_id = aws_route53_key_signing_key.this.hosted_zone_id
}
