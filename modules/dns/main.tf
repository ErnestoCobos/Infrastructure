resource "vultr_dns_record" "record" {
    domain = var.record_domain
    name = var.record_name
    data = var.record_data
    type = var.record_type
}