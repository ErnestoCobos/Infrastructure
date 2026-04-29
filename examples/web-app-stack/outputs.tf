output "vercel_project" {
  value = module.web_app_stack.vercel_project
}

output "supabase_project" {
  value     = module.web_app_stack.supabase_project
  sensitive = true
}

output "vercel_domains" {
  value = module.web_app_stack.vercel_domains
}

output "cloudflare_dns_records" {
  value = module.web_app_stack.cloudflare_dns_records
}
