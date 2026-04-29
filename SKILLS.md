# Repository Skills

This file documents the operating skills this repo expects from humans and coding agents.

## Cloudflare DNS With Terraform

Use `modules/cloudflare-zones` to manage Cloudflare zones and DNS records.

What belongs here:

- Zone creation or adoption.
- DNS records such as A, AAAA, CNAME, TXT, MX, SRV, CAA, and verification records.
- Outputs for zone IDs and assigned name servers.

What does not belong here yet:

- Cloudflare Tunnel.
- Cloudflare Zero Trust.
- Workers, Pages, WAF, rulesets, load balancers, or access policies.

## 1Password Secret Loading

Secrets are not written into Terraform files. The local workflow uses:

```bash
op run --env-file .env.1password -- terraform ...
```

Required runtime variables:

- `CLOUDFLARE_API_TOKEN`
- `TF_TOKEN_app_terraform_io`

## Local Terraform CI

The local CI surface is the `Makefile`:

```bash
make ci
make validate-all
make plan PROJECT=cobosio/cobos-io
```

`plan` and `apply` are intentionally manual. There is no auto-apply path.

## HCP Terraform Workspace Mapping

Use separate HCP Terraform organizations and workspaces:

| HCP organization | Project | Workspace |
| --- | --- | --- |
| `cobosio` | `cobos.io` | `cobos-io-cloudflare-dns` |
| `voltaflow` | `getdecant` | `getdecant-cloudflare-dns` |
| `voltaflow` | `voltaflow` | `voltaflow-cloudflare-dns` |
| `voltaflow` | `enkiflow` | `enkiflow-cloudflare-dns` |

Set each workspace to local execution in HCP Terraform when the workspace is created.

## GitHub Wiki Publishing

The wiki source lives in `wiki/`. Publish it to GitHub Wiki by pushing those Markdown files to:

```bash
git@github.com:ErnestoCobos/Infrastructure.wiki.git
```

If GitHub returns `Repository not found`, create the first wiki page from the GitHub web UI while signed in. GitHub only exposes the `.wiki.git` remote after that first page exists.
