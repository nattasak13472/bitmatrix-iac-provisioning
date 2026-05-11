variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "root_domain_name" {
  type = string
}

variable "common_tags" {
  type = map(string)
}
