# Claude Instructions

Follow `AGENTS.md` first.

## Current Architecture

Terraform is organized as local-first project roots:

- `projects/cobosio/cobos-io`
- `projects/voltaflow/getdecant`
- `projects/voltaflow/voltaflow`
- `projects/voltaflow/enkiflow`

Each root uses HCP Terraform for state and points to `modules/cloudflare-zones` for Cloudflare zone and DNS record management.

For app stacks, use `modules/web-app-stack` to combine Vercel, Supabase, and optional Cloudflare DNS.

## Guardrails

- Do not commit secrets, real local `.tfvars`, Terraform state, or generated plans.
- Do not introduce Cloudflare Tunnel resources.
- Do not replace the local-first workflow with hosted CI.
- Do not put Vercel or Supabase tokens in Terraform files; use `VERCEL_API_TOKEN` and `SUPABASE_ACCESS_TOKEN` through 1Password.
- Keep changes small and directly tied to the requested infrastructure surface.
- Use Spanish for user-facing docs when possible.

## Local Commands

```bash
make doctor
make fmt
make validate PROJECT=cobosio/cobos-io
make plan PROJECT=cobosio/cobos-io
```

Secrets should be loaded through 1Password:

```bash
cp .env.1password.example .env.1password
op run --env-file .env.1password -- terraform -chdir=projects/cobosio/cobos-io plan
```
