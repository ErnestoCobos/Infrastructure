variable "region" {
  description = "region"
  type        = string
}

variable "vpc-one-name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc-one-description" {
  description = "Description of the vpc"
  type        = string
}

variable "vpn_instance_tags" {
  type        = list(string)
  description = "The tags of the VPN instance to create"
}

variable "vpn_instance_hostname" {
  type        = string
  description = "The tags of the VPN instance to create"
}
variable "domain_one" {
  type        = string
  description = "The domain to create the record in"
}
variable "ssh_key_ids" {
  type        = list(string)
  description = "The SSH key IDs of the instance to create"
}