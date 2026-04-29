variable "cloudflare_account_id" {
  description = "Cloudflare account ID for the voltaflow organization."
  type        = string
}

variable "zones" {
  description = "Cloudflare zones and DNS records for Get Decant."
  type        = any
  default     = {}
}
