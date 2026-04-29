output "zones" {
  description = "Cloudflare zone metadata."
  value       = module.cloudflare_zones.zones
}

output "records" {
  description = "Managed DNS records."
  value       = module.cloudflare_zones.records
}
