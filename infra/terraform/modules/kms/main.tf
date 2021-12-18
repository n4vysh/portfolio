provider "aws" {
  region = "ap-northeast-1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "secondary"
}

resource "aws_kms_key" "primary" {
  multi_region = true
}

resource "aws_kms_alias" "primary" {
  name          = "alias/${var.name}/primary"
  target_key_id = aws_kms_key.primary.key_id
}

resource "aws_kms_replica_key" "secondary" {
  primary_key_arn = aws_kms_key.primary.arn

  provider = aws.secondary
}

resource "aws_kms_alias" "secondary" {
  name          = "alias/${var.name}/secondary"
  target_key_id = aws_kms_replica_key.secondary.key_id

  provider = aws.secondary
}
