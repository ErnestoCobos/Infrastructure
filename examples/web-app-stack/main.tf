terraform {
  required_version = ">= 1.11.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 5.0, < 6.0"
    }

    supabase = {
      source  = "supabase/supabase"
      version = ">= 1.9.0, < 2.0"
    }

    vercel = {
      source  = "vercel/vercel"
      version = ">= 4.7.0, < 5.0"
    }
  }
}

provider "cloudflare" {}
provider "supabase" {}
provider "vercel" {}

locals {
  supabase_project = var.supabase_project == null ? null : {
    organization_id   = var.supabase_project.organization_id
    name              = var.supabase_project.name
    database_password = var.supabase_database_password
    region            = var.supabase_project.region
    instance_size     = try(var.supabase_project.instance_size, "micro")
    api_settings      = try(var.supabase_project.api_settings, null)
    auth_settings     = try(var.supabase_project.auth_settings, null)
    database_settings = try(var.supabase_project.database_settings, null)
    network_settings  = try(var.supabase_project.network_settings, null)
    pooler_settings   = try(var.supabase_project.pooler_settings, null)
    storage_settings  = try(var.supabase_project.storage_settings, null)
  }
}

module "web_app_stack" {
  source = "../../modules/web-app-stack"

  stack_name = var.stack_name

  vercel_project               = var.vercel_project
  supabase_project             = local.supabase_project
  supabase_to_vercel           = var.supabase_to_vercel
  vercel_environment_variables = var.vercel_environment_variables
  primary_domains              = var.primary_domains
  vercel_domains               = var.vercel_domains
  cloudflare_dns_records       = var.cloudflare_dns_records
}
