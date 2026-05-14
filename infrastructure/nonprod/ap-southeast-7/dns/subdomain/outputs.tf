output "np_zone_id" {
  value = module.dns_np.zone_id
}

output "np_name_servers" {
  value = module.dns_np.name_servers
}

output "dr_zone_id" {
  value = module.dns_dr.zone_id
}

output "dr_name_servers" {
  value = module.dns_dr.name_servers
}

output "np_private_zone_id" {
  value = module.dns_np_private.zone_id
}

output "np_private_name_servers" {
  value = module.dns_np_private.name_servers
}

output "dr_private_zone_id" {
  value = module.dns_dr_private.zone_id
}

output "dr_private_name_servers" {
  value = module.dns_dr_private.name_servers
}
