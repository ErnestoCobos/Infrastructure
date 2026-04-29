# cobos.io Cloudflare DNS

HCP Terraform:

- Organization: `cobosio`
- Project: `cobos.io`
- Workspace: `cobos-io-cloudflare-dns`

Before the first real apply:

1. Configure the HCP workspace with local execution.
2. Copy `terraform.tfvars.example` to `terraform.tfvars`.
3. Put real DNS inventory in local `terraform.tfvars`.
4. Import the existing `cobos.io` Cloudflare zone and DNS records.
5. Run `make plan PROJECT=cobosio/cobos-io`.
