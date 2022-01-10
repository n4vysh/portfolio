locals {
  prefix = "alias/${var.project}/${var.name}/${var.env.short}"
  name = {
    primary = "${local.prefix}/primary"
    replica = "${local.prefix}/replica"
  }
}

resource "aws_kms_key" "this" {
  # checkov:skip=CKV_AWS_7:for cost reduction
  #ts:skip=AC_AWS_0160 for cost reduction
  # If you enable automatic key rotation, each newly generated backing key costs an additional $1/month.
  # https://aws.amazon.com/kms/pricing/?nc1=h_ls

  multi_region = true

  tags = {
    Project     = var.project
    Name        = local.name.primary
    Environment = var.env.long
  }
}

resource "aws_kms_replica_key" "this" {
  provider = aws.secondary

  primary_key_arn = aws_kms_key.this.arn

  tags = {
    Project     = var.project
    Name        = local.name.replica
    Environment = var.env.long
  }
}

resource "aws_kms_alias" "primary" {
  name          = local.name.primary
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_kms_alias" "replica" {
  provider = aws.secondary

  name          = local.name.replica
  target_key_id = aws_kms_replica_key.this.key_id
}
