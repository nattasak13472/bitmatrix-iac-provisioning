# DNS Zone Lookup
data "aws_route53_zone" "selected" {
  name         = var.root_domain_name
  private_zone = false
}

# ACM FOR VPN
module "vpn_cert" {
  source = "../../../../../../iac-modules/security/acm"

  project     = var.project
  environment = var.environment
  domain_name = var.vpn_server_domain_name
  common_tags = var.common_tags
}

# DNS Validation for ACM
resource "aws_route53_record" "vpn_cert_validation" {
  for_each = {
    for dvo in module.vpn_cert.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.selected.zone_id
}

# VPN DNS Record
resource "aws_route53_record" "vpn_endpoint" {
  count   = var.vpn_endpoint_dns_name != null ? 1 : 0
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.vpn_server_domain_name
  type    = "CNAME"
  ttl     = 300
  records = [var.vpn_endpoint_dns_name]
}
