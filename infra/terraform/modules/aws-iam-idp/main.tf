data "tls_certificate" "this" {
  url = "https://${var.provider_url}/.well-known/openid-configuration"
}

resource "aws_iam_openid_connect_provider" "this" {
  url = "https://${var.provider_url}"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]

  tags = {
    Project     = var.project
    Name        = var.name
    Environment = var.env.long
  }
}
