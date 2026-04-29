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
