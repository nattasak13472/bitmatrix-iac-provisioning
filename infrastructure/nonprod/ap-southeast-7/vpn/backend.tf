terraform {
  backend "s3" {
    key = "infrastructure/nonprod/ap-southeast-7/vpn/terraform.tfstate"
  }
}
