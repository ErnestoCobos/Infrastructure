# Web App Stack

The `modules/web-app-stack` module creates a reusable app stack:

- Vercel project.
- Supabase project.
- Vercel environment variables wired from Supabase.
- Vercel domains.
- Cloudflare DNS.

## Providers

Runtime tokens are loaded from 1Password:

```dotenv
VERCEL_API_TOKEN=op://Infrastructure/Vercel/VERCEL_API_TOKEN
SUPABASE_ACCESS_TOKEN=op://Infrastructure/Supabase/SUPABASE_ACCESS_TOKEN
CLOUDFLARE_API_TOKEN=op://Infrastructure/Cloudflare/CLOUDFLARE_API_TOKEN
```

## Safety

- Uses Terraform `value_wo` for Vercel environment variable values.
- Requires Terraform `>= 1.11`.
- Supabase `database_password` is sensitive, but the provider can still place it in Terraform state; use HCP Terraform remote state for real stacks.
- Does not include Cloudflare Tunnel.
- Does not inject Supabase service role keys unless explicitly enabled.

## Example

See `examples/web-app-stack`.
