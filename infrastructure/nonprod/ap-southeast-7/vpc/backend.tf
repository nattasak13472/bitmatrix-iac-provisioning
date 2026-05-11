terraform {
  backend "s3" {
    key = "infrastructure/nonprod/ap-southeast-7/vpc/terraform.tfstate"
  }
}
