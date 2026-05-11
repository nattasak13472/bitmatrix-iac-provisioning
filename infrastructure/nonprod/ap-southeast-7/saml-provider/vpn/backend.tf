terraform {
  backend "s3" {
    key = "infrastructure/nonprod/ap-southeast-7/saml-provider/vpn/terraform.tfstate"
  }
}
