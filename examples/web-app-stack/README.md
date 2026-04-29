# Web App Stack Example

This example shows how to create a full web app stack with:

- Vercel project
- Supabase project
- Vercel environment variables generated from Supabase
- optional Vercel domain
- optional Cloudflare DNS
- primary apex-to-canonical domain wiring

Use this as a template or validation target. For a real stack, copy the shape into `projects/<org>/<stack>` with HCP Terraform remote state instead of applying this example directly with local state.

Copy the example variables locally:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Do not commit `terraform.tfvars`.

Prefer loading the Supabase password from 1Password:

```dotenv
TF_VAR_supabase_database_password=op://Infrastructure/example-app/SUPABASE_DATABASE_PASSWORD
```

Run with 1Password:

```bash
op run --env-file ../../.env.1password -- terraform init
op run --env-file ../../.env.1password -- terraform plan
```
