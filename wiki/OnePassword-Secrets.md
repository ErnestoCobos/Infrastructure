# 1Password Secrets

Secrets are resolved at runtime with 1Password CLI.

Copy the example file:

```bash
cp .env.1password.example .env.1password
```

Expected variables:

```dotenv
CLOUDFLARE_API_TOKEN=op://Infrastructure/Cloudflare/CLOUDFLARE_API_TOKEN
TF_TOKEN_app_terraform_io=op://Infrastructure/HCP Terraform/TF_TOKEN_app_terraform_io
```

Run Terraform through the wrapper:

```bash
make plan PROJECT=cobosio/cobos-io
```

The wrapper expands secrets with:

```bash
op run --env-file .env.1password -- terraform ...
```

Do not commit `.env.1password`, `.tfvars`, state files, or plan files.
