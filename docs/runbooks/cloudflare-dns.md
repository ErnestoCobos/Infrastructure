# Cloudflare DNS Runbook

## First-Time Adoption

1. Confirm the domain exists in the correct Cloudflare account.
2. Export the current DNS records from Cloudflare.
3. Add the records to local `terraform.tfvars`.
4. Run `make init PROJECT=<org>/<project>`.
5. Import the existing zone and records.
6. Run `make plan PROJECT=<org>/<project>`.
7. Apply only after the plan shows no unintended deletes or recreations.

## Imports

Zone:

```bash
terraform -chdir=projects/cobosio/cobos-io import \
  'module.cloudflare_zones.cloudflare_zone.managed["cobos.io"]' \
  '<zone_id>'
```

DNS record:

```bash
terraform -chdir=projects/cobosio/cobos-io import \
  'module.cloudflare_zones.cloudflare_dns_record.this["cobos.io/www-cname"]' \
  '<zone_id>/<dns_record_id>'
```

## Namecheap

After Cloudflare assigns name servers, change the registrar name servers manually in Namecheap. Do not automate registrar changes from Terraform yet.

For `cobos.io`, the Cloudflare name servers assigned during setup were:

- `carmelo.ns.cloudflare.com`
- `pat.ns.cloudflare.com`
