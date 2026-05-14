module "dns" {
  source = "../../../../../../iac-modules/networking/route53"

  project     = var.project
  environment = var.environment
  domain_name = var.root_domain_name
  common_tags = var.common_tags
}

module "dns_private" {
  source = "../../../../../../iac-modules/networking/route53"

  project         = var.project
  environment     = var.environment
  domain_name     = var.root_domain_name
  common_tags     = var.common_tags
  is_private_zone = true
  vpc_ids         = var.vpc_ids
}
