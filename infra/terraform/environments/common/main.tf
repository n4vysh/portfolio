provider "aws" {
  region = "ap-northeast-1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "secondary"
}

resource "aws_kms_key" "helmfile" {
  multi_region = true
}

resource "aws_kms_alias" "helmfile_primary" {
  name          = "alias/helmfile/primary"
  target_key_id = aws_kms_key.helmfile.key_id
}

resource "aws_kms_replica_key" "helmfile" {
  primary_key_arn = aws_kms_key.helmfile.arn

  provider = aws.secondary
}

resource "aws_kms_alias" "helmfile_secondary" {
  name          = "alias/helmfile/secondary"
  target_key_id = aws_kms_replica_key.helmfile.key_id

  provider = aws.secondary
}
