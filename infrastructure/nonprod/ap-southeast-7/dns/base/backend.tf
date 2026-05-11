terraform {
  backend "s3" {
    key = "infrastructure/nonprod/ap-southeast-7/dns/base/terraform.tfstate"
  }
}
