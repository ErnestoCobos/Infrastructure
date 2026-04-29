# Agent Instructions

This repository manages personal and company infrastructure. Treat every change as production-adjacent, even when the current task is documentation.

## Scope

- Terraform is local-first. Do not add GitHub Actions, hosted CI, or automatic remote applies for Terraform unless Ernesto explicitly asks for that.
- HCP Terraform is used for remote state and workspace history. The intended execution mode is local execution from Ernesto's machine.
- Cloudflare is currently limited to zones and DNS records. Do not add Cloudflare Tunnel, Zero Trust, Workers, WAF, or Pages resources unless explicitly requested.
- Vercel and Supabase app stacks belong in `modules/web-app-stack`; keep them local-first and 1Password-backed.
- Keep real secrets out of git. Use 1Password references and `op run` for tokens.
- This repo is public unless GitHub visibility is changed; do not commit private DNS targets, API tokens, account tokens, SSH keys, or generated state.

## Author Identity

Only these commit author emails are allowed:

- `ernesto@voltaflow.com`
- `ernesto@cobos.io`

Do not add AI-generated attribution, co-author trailers, or tool names to commits, pull requests, changelogs, or docs unless explicitly requested.

## Terraform Workflow

- Prefer the reusable module in `modules/cloudflare-zones`.
- Add project roots under `projects/<hcp-org>/<project-name>`.
- Keep one HCP Terraform workspace per project/domain group. Avoid one giant state for unrelated companies or products.
- Run Terraform through `make` or `scripts/tf-local.sh` so credentials resolve through 1Password.
- Before `apply`, run `make plan PROJECT=<org>/<project>` and inspect the plan.
- Import existing Cloudflare zones and DNS records into state before the first apply. Never let Terraform recreate a live zone because it was not imported.

## Validation

Before finalizing:

- Run `git diff --check`.
- Run shell syntax checks for scripts.
- Run Terraform formatting and validation when `terraform` is installed.
- When useful, ask peer CLI tools such as Codex, Gemini, and Copilot to review the diff.

If a required tool is missing, say exactly what could not be tested and why.
