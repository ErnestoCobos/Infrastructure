variable "stack_name" {
  description = "Stack name."
  type        = string
}

variable "vercel_project" {
  description = "Vercel project configuration."
  type        = any
}

variable "supabase_project" {
  description = "Supabase project configuration without the database password."
  type        = any
  default     = null
}

variable "supabase_database_password" {
  description = "Supabase database password, loaded through 1Password or another local secret source."
  type        = string
  default     = null
  sensitive   = true
}

variable "supabase_to_vercel" {
  description = "Supabase to Vercel wiring."
  type        = any
  default     = {}
}

variable "vercel_environment_variables" {
  description = "Additional Vercel environment variables."
  type        = any
  default     = {}
}

variable "primary_domains" {
  description = "Canonical primary domains that generate Vercel domains and Cloudflare DNS."
  type        = any
  default     = {}
}

variable "vercel_domains" {
  description = "Vercel domains."
  type        = any
  default     = {}
}

variable "cloudflare_dns_records" {
  description = "Cloudflare DNS records."
  type        = any
  default     = {}
}
