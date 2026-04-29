terraform {
  required_version = ">= 1.5.0"

  cloud {
    organization = "voltaflow"

    workspaces {
      project = "getdecant"
      name    = "getdecant-cloudflare-dns"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 5.0, < 6.0"
    }
  }
}

provider "cloudflare" {}

module "cloudflare_zones" {
  source = "../../../modules/cloudflare-zones"

  account_id = var.cloudflare_account_id
  zones      = var.zones
}
