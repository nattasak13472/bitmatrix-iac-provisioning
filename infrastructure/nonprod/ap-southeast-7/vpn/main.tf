# VPN
module "vpn" {
  source = "../../../../../../iac-modules/networking/vpn"

  project                        = var.project
  environment                    = var.environment
  region                         = var.region
  vpc_id                         = var.vpc_id
  vpc_cidr_block                 = var.vpc_cidr_block
  private_app_subnet_ids         = var.private_app_subnet_ids
  client_vpn_client_cidr         = var.client_vpn_client_cidr
  saml_provider_arn              = var.saml_provider_arn
  self_service_saml_provider_arn = var.self_service_saml_provider_arn
  client_vpn_server_cert_arn     = var.client_vpn_server_cert_arn
  common_tags                    = var.common_tags
}
