variable "stack_name" {
  description = "Human-readable stack name used for tagging comments and defaults."
  type        = string
}

variable "vercel_project" {
  description = "Vercel project configuration."
  type = object({
    name                                              = string
    framework                                         = optional(string, "nextjs")
    team_id                                           = optional(string)
    root_directory                                    = optional(string)
    build_command                                     = optional(string)
    install_command                                   = optional(string)
    output_directory                                  = optional(string)
    dev_command                                       = optional(string)
    node_version                                      = optional(string)
    automatically_expose_system_environment_variables = optional(bool, true)
    auto_assign_custom_domains                        = optional(bool, true)
    git_repository = optional(object({
      type              = string
      repo              = string
      production_branch = optional(string, "main")
    }))
  })
}

variable "supabase_project" {
  description = "Supabase project configuration. Set to null to skip Supabase."
  type = object({
    organization_id   = string
    name              = string
    database_password = string
    region            = string
    instance_size     = optional(string, "micro")
    api_settings      = optional(any)
    auth_settings     = optional(any)
    database_settings = optional(any)
    network_settings  = optional(any)
    pooler_settings   = optional(any)
    storage_settings  = optional(any)
  })
  default = null
}

variable "supabase_to_vercel" {
  description = "Controls which Supabase-generated values are injected into the Vercel project."
  type = object({
    enabled                          = optional(bool, true)
    include_publishable_key          = optional(bool, true)
    include_legacy_anon_key          = optional(bool, false)
    include_legacy_service_role_key  = optional(bool, false)
    include_transaction_database_url = optional(bool, false)
    targets                          = optional(set(string), ["production", "preview"])
  })
  default = {}
}

variable "vercel_environment_variables" {
  description = "Additional Vercel environment variables. Values use write-only provider arguments so they do not persist in Terraform state."
  type = map(object({
    key                    = string
    value                  = string
    target                 = optional(set(string))
    custom_environment_ids = optional(set(string))
    git_branch             = optional(string)
    sensitive              = optional(bool, true)
    comment                = optional(string)
  }))
  default = {}
}

variable "vercel_domains" {
  description = "Vercel domains to attach to the project."
  type = map(object({
    domain                = string
    redirect              = optional(string)
    redirect_status_code  = optional(number)
    git_branch            = optional(string)
    custom_environment_id = optional(string)
  }))
  default = {}
}

variable "cloudflare_dns_records" {
  description = "Optional Cloudflare DNS records that point the stack domains at Vercel."
  type = map(object({
    zone_id  = string
    name     = string
    type     = string
    content  = string
    ttl      = optional(number, 1)
    proxied  = optional(bool, false)
    priority = optional(number)
    comment  = optional(string)
    tags     = optional(set(string), [])
    settings = optional(any)
  }))
  default = {}
}
