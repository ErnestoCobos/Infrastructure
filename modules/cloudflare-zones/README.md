# cloudflare-zones

Reusable Terraform module for Cloudflare zones and DNS records.

## Intent

This module handles the current Cloudflare scope only:

- zones
- DNS records
- assigned name server outputs

It intentionally does not manage Cloudflare Tunnel or Zero Trust.

## Usage

```hcl
module "cloudflare_zones" {
  source = "../../../modules/cloudflare-zones"

  account_id = var.account_id

  zones = {
    "example.com" = {
      records = {
        "apex-a" = {
          name    = "example.com"
          type    = "A"
          content = "203.0.113.10"
          proxied = false
        }

        "mail-mx-1" = {
          name     = "example.com"
          type     = "MX"
          content  = "mx01.example.net"
          priority = 10
        }
      }
    }
  }
}
```

## Existing Zones

If Terraform should manage the zone itself, omit `zone_id` and import the existing Cloudflare zone before the first apply:

```bash
terraform import 'module.cloudflare_zones.cloudflare_zone.managed["example.com"]' '<zone_id>'
```

If you need a read-only adoption step first, set `zone_id` in the zone object. Terraform will look up the zone and manage only records declared in `records`.

## Existing DNS Records

Import existing DNS records before the first apply:

```bash
terraform import \
  'module.cloudflare_zones.cloudflare_dns_record.this["example.com/www-cname"]' \
  '<zone_id>/<dns_record_id>'
```

Use stable record keys like `www-cname`, `apex-a`, or `mail-mx-1`. Changing the key changes the Terraform address.
