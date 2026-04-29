variable "cloudflare_account_id" {
  description = "Cloudflare account ID for the cobosio organization."
  type        = string
}

variable "zones" {
  description = "Cloudflare zones and DNS records for cobos.io."
  type        = any
  default     = {}
}
