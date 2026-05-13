terraform {
  backend "s3" {
    key = "infrastructure/production/ap-southeast-1/vpc/terraform.tfstate"
  }
}
