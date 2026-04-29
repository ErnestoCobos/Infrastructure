# web-app-stack

Opinionated web app stack module for:

- Vercel project
- Supabase project
- optional Vercel project domains
- optional Cloudflare DNS records for those domains
- optional Supabase values injected into Vercel environment variables

The module is designed for local-first Terraform execution with secrets loaded through 1Password.

## Secret Model

Provider tokens should come from environment variables:

- `VERCEL_API_TOKEN`
- `SUPABASE_ACCESS_TOKEN`
- `CLOUDFLARE_API_TOKEN`

Project-specific secrets should come from Terraform variables loaded through `op run`, for example:

```dotenv
TF_VAR_supabase_database_password=op://Infrastructure/my-stack/SUPABASE_DATABASE_PASSWORD
```

Vercel environment variables use the provider's `value_wo` write-only argument, so values are sent to Vercel without being stored in Terraform state. This requires Terraform `>= 1.11`.

Supabase currently requires the database password as a provider argument during project creation. Terraform marks it sensitive, but it can still exist inside state. For real stacks, use the repo's HCP Terraform-backed project roots and restrict state access; do not apply the standalone example with local state.

## Example

```hcl
module "web_app_stack" {
  source = "../../modules/web-app-stack"

  stack_name = "my-app"

  vercel_project = {
    name      = "my-app"
    framework = "nextjs"
    git_repository = {
      type              = "github"
      repo              = "ErnestoCobos/my-app"
      production_branch = "main"
    }
  }

  supabase_project = {
    organization_id   = "vercel_icfg_4aIoqtoZpraO23BVvWwmEMNL"
    name              = "my-app"
    database_password = var.supabase_database_password
    region            = "us-east-1"
    instance_size     = "micro"
  }

  supabase_to_vercel = {
    enabled                 = true
    include_publishable_key = true
    targets                 = ["production", "preview"]
  }
}
```

## Domain Wiring

For an apex domain on Vercel, point Cloudflare to `76.76.21.21`.

For a subdomain, point Cloudflare to `cname.vercel-dns.com`.

Example:

```hcl
vercel_domains = {
  app = {
    domain = "app.example.com"
  }
}

cloudflare_dns_records = {
  app = {
    zone_id = "REPLACE_WITH_ZONE_ID"
    name    = "app.example.com"
    type    = "CNAME"
    content = "cname.vercel-dns.com"
    proxied = false
  }
}
```

## Safety Defaults

- Supabase publishable keys are preferred for generated Vercel environment variables.
- Supabase legacy anon and service role keys are not injected into Vercel by default.
- Cloudflare Tunnel is out of scope.
- The module creates projects and settings, but does not deploy app code.
