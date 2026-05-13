terraform {
  backend "s3" {
    key = "infrastructure/production/ap-southeast-7/vpc/terraform.tfstate"
  }
}
