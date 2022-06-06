terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "2.11.2"
    }
  }
  cloud {
    organization = "cobos"

    workspaces {
      name = "Avenegra"
    }
  }
} 