# Terraform Operations

## Project Map

| Local project | HCP organization | HCP project | Workspace |
| --- | --- | --- | --- |
| `cobosio/cobos-io` | `cobosio` | `cobos.io` | `cobos-io-cloudflare-dns` |
| `voltaflow/getdecant` | `voltaflow` | `getdecant` | `getdecant-cloudflare-dns` |
| `voltaflow/voltaflow` | `voltaflow` | `voltaflow` | `voltaflow-cloudflare-dns` |
| `voltaflow/enkiflow` | `voltaflow` | `enkiflow` | `enkiflow-cloudflare-dns` |

## Commands

```bash
make doctor
make fmt
make validate PROJECT=cobosio/cobos-io
make plan PROJECT=cobosio/cobos-io
make apply PROJECT=cobosio/cobos-io
```

## Rules

- Plan before apply.
- Import existing resources before the first apply.
- Keep Terraform execution local.
- Store state in HCP Terraform.
- Keep `.tfvars` local unless the values are safe to publish.
