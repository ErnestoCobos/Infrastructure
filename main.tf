provider "vultr" {
  rate_limit = 700
  retry_limit = 3
}

# Global VPC

module "vpc" {
  source = "./modules/vpc"
  vpc_name = var.vpc-one-name
  vpc_region = var.region
  vpc_description = var.vpc-one-description
}

# VPN 
module "vpn" {
  source = "./components/vpn"
  region = var.region
  vpn_hostname = var.vpn_instance_hostname
  vpn_tags = var.vpn_instance_tags
  vpc_id = module.vpc.vpc_id
  ssh_key_ids = var.ssh_key_ids
  domain = data.vultr_dns_domain.service_domain.id
}
