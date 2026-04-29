# Cloudflare Zones

Terraform currently manages:

- Cloudflare zones.
- DNS records.
- Name server outputs.

Terraform does not manage:

- Cloudflare Tunnel.
- Zero Trust.
- Workers.
- Pages.
- WAF or rulesets.

## Adoption Flow

1. Audit existing DNS in Cloudflare.
2. Add records to local `terraform.tfvars`.
3. Import the zone:

```bash
terraform -chdir=projects/cobosio/cobos-io import \
  'module.cloudflare_zones.cloudflare_zone.managed["cobos.io"]' \
  '<zone_id>'
```

4. Import each record:

```bash
terraform -chdir=projects/cobosio/cobos-io import \
  'module.cloudflare_zones.cloudflare_dns_record.this["cobos.io/www-cname"]' \
  '<zone_id>/<dns_record_id>'
```

5. Run plan and confirm there are no destructive changes.

## Cobos.io Name Servers

Assigned Cloudflare name servers:

- `carmelo.ns.cloudflare.com`
- `pat.ns.cloudflare.com`
