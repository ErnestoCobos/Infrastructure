resource "vultr_vpc" "my_vpc" {
    description = var.vpc_description
    region = var.vpc_region
}