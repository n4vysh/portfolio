output "kms_alias_arn" {
  description = "Amazon Resource Names of AWS KMS alias"
  value = {
    primary = aws_kms_alias.primary.arn
    replica = aws_kms_alias.replica.arn
  }
}
