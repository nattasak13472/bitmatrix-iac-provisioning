module "acm" {
  source = "../../../../../../iac-modules/security/acm"

  project                   = var.project
  environment               = var.environment
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"
  common_tags               = var.common_tags
}

data "aws_route53_zone" "this" {
  name         = var.domain_name
  private_zone = false
}

locals {
  dvos = {
    for dvo in module.acm.domain_validation_options : replace(dvo.domain_name, "*.", "") => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }...
  }
}

resource "aws_route53_record" "validation" {
  for_each = { for k, v in local.dvos : k => v[0] }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this.zone_id
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = module.acm.certificate_arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
