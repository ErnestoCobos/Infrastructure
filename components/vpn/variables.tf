variable "region" {
  description = "Region of the VPC"
  type = string
}

variable "vpn_hostname"   {
  description = "Hostname of the VPN instance"
  type = string
}   

variable "vpn_tags" {
  type = list(string)
  description = "The tags of the instance to create"
}

variable "vpc_id" {
  type = string
  description = "ID of the VPC"
}

variable "ssh_key_ids" {
  type = list(string)
  description = "The SSH key IDs of the instance to create"
}

variable "domain" {
  type = string
  description = "Domain name of the VPN instance"
}
