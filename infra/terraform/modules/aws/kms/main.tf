terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.0.5"
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Environment = var.env
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "secondary"

  default_tags {
    tags = {
      Environment = var.env
    }
  }
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
