output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.subnets.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "List of IDs of private app subnets"
  value       = module.subnets.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "List of IDs of private database subnets"
  value       = module.subnets.private_db_subnet_ids
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.internet_gateway.internet_gateway_id
}

output "nat_gateway_public_ips" {
  description = "List of public IPs of the NAT Gateways"
  value       = module.nat_gateway.nat_gateway_public_ips
}
