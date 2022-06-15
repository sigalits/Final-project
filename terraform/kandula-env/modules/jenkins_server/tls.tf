## TLS
resource "tls_private_key" "kandula_tls" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "kandula_tls" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.kandula_tls.private_key_pem

  subject {
    common_name  = "jenkins.kandula"
    organization = "opsschool project"
  }

  validity_period_hours = 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "kandula_tls" {
  private_key      = tls_private_key.kandula_tls.private_key_pem
  certificate_body = tls_self_signed_cert.kandula_tls.cert_pem
}

