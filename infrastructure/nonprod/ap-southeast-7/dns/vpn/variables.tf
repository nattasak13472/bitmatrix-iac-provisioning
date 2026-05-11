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

variable "vpn_server_domain_name" {
  type = string
}

variable "vpn_endpoint_dns_name" {
  description = "The DNS name of the Client VPN endpoint (manual input)"
  type        = string
  default     = null
}

variable "common_tags" {
  type = map(string)
}
