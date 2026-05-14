terraform {
  backend "s3" {
    key = "infrastructure/nonprod/ap-southeast-7/acm/np_ntk/terraform.tfstate"
  }
}
