module "dns_np" {
  source = "../../../../../../iac-modules/networking/route53"

  project     = var.project
  environment = var.environment
  domain_name = "np.${var.root_domain_name}"
  common_tags = var.common_tags
}

module "dns_dr" {
  source = "../../../../../../iac-modules/networking/route53"

  project     = var.project
  environment = var.environment
  domain_name = "dr.${var.root_domain_name}"
  common_tags = var.common_tags
}

module "dns_np_private" {
  source = "../../../../../../iac-modules/networking/route53"

  project         = var.project
  environment     = var.environment
  domain_name     = "np.${var.root_domain_name}"
  common_tags     = var.common_tags
  is_private_zone = true
  vpc_ids         = var.vpc_ids
}

module "dns_dr_private" {
  source = "../../../../../../iac-modules/networking/route53"

  project         = var.project
  environment     = var.environment
  domain_name     = "dr.${var.root_domain_name}"
  common_tags     = var.common_tags
  is_private_zone = true
  vpc_ids         = var.vpc_ids
}

# Look up the root zone created by the base/ directory
data "aws_route53_zone" "root" {
  name         = var.root_domain_name
  private_zone = false
}

# Delegate the np sub-domain to its new name servers
resource "aws_route53_record" "np_ns_delegation" {
  zone_id = data.aws_route53_zone.root.zone_id
  name    = "np.${var.root_domain_name}"
  type    = "NS"
  ttl     = 300
  records = module.dns_np.name_servers
}

# Delegate the dr sub-domain to its new name servers
resource "aws_route53_record" "dr_ns_delegation" {
  zone_id = data.aws_route53_zone.root.zone_id
  name    = "dr.${var.root_domain_name}"
  type    = "NS"
  ttl     = 300
  records = module.dns_dr.name_servers
}
