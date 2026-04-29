output "vercel_project" {
  description = "Vercel project metadata."
  value = {
    id      = vercel_project.this.id
    name    = vercel_project.this.name
    team_id = local.vercel_team_id
  }
}

output "vercel_domains" {
  description = "Attached Vercel domains."
  value = {
    for key, domain in vercel_project_domain.this : key => {
      id     = domain.id
      domain = domain.domain
    }
  }
}

output "supabase_project" {
  description = "Supabase project metadata."
  value = local.supabase_enabled ? {
    ref = supabase_project.this[0].id
    url = local.supabase_url
  } : null
  sensitive = true
}

output "cloudflare_dns_records" {
  description = "Cloudflare DNS records managed by the stack."
  value = {
    for key, record in cloudflare_dns_record.this : key => {
      id      = record.id
      name    = record.name
      type    = record.type
      zone_id = record.zone_id
    }
  }
}
