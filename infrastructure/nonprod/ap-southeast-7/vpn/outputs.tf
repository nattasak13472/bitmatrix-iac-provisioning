output "vpn_endpoint_id" {
  description = "The ID of the Client VPN endpoint"
  value       = module.vpn.vpn_endpoint_id
}

output "vpn_endpoint_dns_name" {
  description = "The DNS name of the Client VPN endpoint"
  value       = module.vpn.vpn_endpoint_dns_name
}
