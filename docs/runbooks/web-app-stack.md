# Web App Stack Runbook

The `modules/web-app-stack` module is the Terraform equivalent of the first infrastructure pass for a build-web-app project.

It can create:

- a Vercel project connected to GitHub
- a Supabase project
- Supabase settings
- Vercel environment variables generated from Supabase
- Vercel project domains
- Cloudflare DNS records for those domains
- primary apex/canonical domain pairs, such as `cobos.io` redirecting to `www.cobos.io`

## Required Tokens

Store these in 1Password and expose them with `op run`:

```dotenv
VERCEL_API_TOKEN=op://Infrastructure/Vercel/VERCEL_API_TOKEN
SUPABASE_ACCESS_TOKEN=op://Infrastructure/Supabase/SUPABASE_ACCESS_TOKEN
CLOUDFLARE_API_TOKEN=op://Infrastructure/Cloudflare/CLOUDFLARE_API_TOKEN
```

For each stack, store a database password in 1Password:

```dotenv
TF_VAR_supabase_database_password=op://Infrastructure/my-stack/SUPABASE_DATABASE_PASSWORD
```

## State Handling

Vercel environment variable values use `value_wo`, so Terraform sends them to Vercel without storing them in state.

Supabase project creation is different: the Supabase provider requires `database_password` as a sensitive argument. It is redacted in plans, but can still be present in Terraform state. Use HCP Terraform remote state for real project roots, keep state access tight, and avoid applying `examples/web-app-stack` directly with local state.

## Recommended Flow

1. Create or pick the GitHub repo for the app.
2. Add a project root under `projects/<org>/<stack>`.
3. Use `modules/web-app-stack`.
4. Keep `terraform.tfvars` local.
5. Run `terraform plan` locally through 1Password.
6. Apply only after reviewing Vercel project, Supabase project, domains, and DNS.

## DNS Rules

- Apex on Vercel: Cloudflare `A` record to `76.76.21.21`.
- Subdomain on Vercel: Cloudflare `CNAME` to `cname.vercel-dns.com`.
- Prefer `primary_domains` for production domains. Set `redirect_apex_to_canonical = true` when the apex should redirect to `www`.

Example:

```hcl
primary_domains = {
  cobos_io = {
    zone_id                    = "REPLACE_WITH_COBOS_IO_ZONE_ID"
    apex_domain                = "cobos.io"
    canonical_domain           = "www.cobos.io"
    redirect_apex_to_canonical = true
    proxied                    = false
  }
}
```

## What This Module Does Not Do

- It does not deploy app code.
- It does not create Cloudflare Tunnel resources.
- It does not inject Supabase legacy anon or service role keys by default.
- It does not store plain secrets in git.
