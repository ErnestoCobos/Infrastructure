variable "cloudflare_account_id" {
  description = "Cloudflare account ID for the voltaflow organization."
  type        = string
}

variable "zones" {
  description = "Cloudflare zones and DNS records for Voltaflow."
  type        = any
  default     = {}
}
