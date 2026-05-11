module "dns" {
  source = "../../../../../../iac-modules/networking/route53"

  project     = var.project
  environment = var.environment
  domain_name = var.root_domain_name
  common_tags = var.common_tags
}
