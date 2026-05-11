variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
}

variable "private_app_subnet_ids" {
  description = "List of private app subnet IDs"
  type        = list(string)
}

variable "client_vpn_client_cidr" {
  description = "CIDR block to be assigned to VPN clients"
  type        = string
}

variable "saml_provider_arn" {
  description = "The ARN of the IAM SAML identity provider for federated authentication"
  type        = string
}

variable "self_service_saml_provider_arn" {
  description = "The ARN of the IAM SAML identity provider for the self-service portal"
  type        = string
  default     = null
}

variable "client_vpn_server_cert_arn" {
  description = "The ARN of the ACM certificate for the VPN server (manual input)"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}
