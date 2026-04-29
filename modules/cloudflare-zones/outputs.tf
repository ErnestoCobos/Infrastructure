output "zones" {
  description = "Managed and referenced Cloudflare zone metadata."
  value = {
    for zone_name in keys(var.zones) : zone_name => {
      id = local.zone_ids[zone_name]
      name_servers = try(
        cloudflare_zone.managed[zone_name].name_servers,
        data.cloudflare_zone.external[zone_name].name_servers,
        []
      )
    }
  }
}

output "records" {
  description = "Managed DNS records keyed by '<zone>/<record-key>'."
  value = {
    for key, record in cloudflare_dns_record.this : key => {
      id      = record.id
      name    = record.name
      type    = record.type
      zone_id = record.zone_id
    }
  }
}
