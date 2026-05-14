output "zone_id" {
  value = module.dns.zone_id
}

output "name_servers" {
  value = module.dns.name_servers
}

output "private_zone_id" {
  value = module.dns_private.zone_id
}

output "private_name_servers" {
  value = module.dns_private.name_servers
}
