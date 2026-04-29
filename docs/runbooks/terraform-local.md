# Terraform Local Workflow

## Why Local

This repo uses HCP Terraform for state and audit history while keeping plan and apply execution on Ernesto's Mac. That keeps access to local-only 1Password secrets simple and avoids hosted CI secrets.

## HCP Terraform Setup

For each workspace:

1. Create or let `terraform init` create the workspace.
2. Set execution mode to local in HCP Terraform.
3. Keep VCS-driven runs disabled for Terraform.
4. Use local `terraform.tfvars` files for records that should not be public.

## Commands

```bash
make doctor
make fmt
make validate PROJECT=cobosio/cobos-io
make plan PROJECT=cobosio/cobos-io
make apply PROJECT=cobosio/cobos-io
```

## Secrets

The wrapper uses `.env.1password` when present:

```bash
op run --env-file .env.1password -- terraform -chdir=projects/cobosio/cobos-io plan
```

Use `TF_TOKEN_app_terraform_io` for HCP Terraform CLI authentication and `CLOUDFLARE_API_TOKEN` for the Cloudflare provider.
