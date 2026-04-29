# Mac Prerequisites

Run:

```bash
./scripts/bootstrap-macos.sh
```

The script installs:

- Terraform from the HashiCorp Homebrew tap.
- 1Password CLI.
- GitHub CLI.
- `jq` and `yq`.
- `shellcheck`.
- `pre-commit`.
- `tflint`.
- `terraform-docs`.
- `checkov`.

After installation:

```bash
op signin
make doctor
```
