resource "vultr_instance" "instance" {
    plan = "vc2-1c-1gb"
    region = var.region
    app_id = 50
    label = var.vpn_hostname
    tags = var.vpn_tags
    hostname =  var.vpn_hostname
    enable_ipv6 = true
    ddos_protection = false
    activation_email = true
    ssh_key_ids = var.ssh_key_ids
    vpc_ids = [var.vpc_id]
    backups = "enabled" # backups should be mandatory
    backups_schedule {
        type = "daily"
    }
}


module "vpn_dns" {
  source = "../../modules/dns"
  record_domain = var.domain
  record_name = var.vpn_hostname
  record_data = vultr_instance.instance.main_ip
  record_type = "A"
}

