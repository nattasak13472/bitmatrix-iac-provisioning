terraform {
  backend "s3" {
    key = "infrastructure/nonprod/ap-southeast-7/dns/subdomain_ntk/terraform.tfstate"
  }
}
