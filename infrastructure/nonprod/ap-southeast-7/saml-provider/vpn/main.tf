module "saml_provider" {
  source = "../../../../../../../iac-modules/security/iam-saml-provider"

  name                   = var.saml_provider_name
  saml_metadata_document = file("${path.module}/files/GoogleIDPMetadata.xml")
  common_tags            = var.common_tags
}
