variable "account_id" {
  description = "Cloudflare account ID where managed zones should live."
  type        = string
}

variable "zones" {
  description = "Map of Cloudflare zones and DNS records to manage."
  type = map(object({
    type    = optional(string, "full")
    zone_id = optional(string)
    records = optional(map(object({
      name            = string
      type            = string
      content         = optional(string)
      ttl             = optional(number, 1)
      proxied         = optional(bool)
      priority        = optional(number)
      comment         = optional(string)
      tags            = optional(set(string), [])
      data            = optional(any)
      settings        = optional(any)
      private_routing = optional(bool)
    })), {})
  }))
  default = {}
}
