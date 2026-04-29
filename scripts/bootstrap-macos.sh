#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This bootstrap script is intended for macOS."
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  cat <<'MSG'
Homebrew is required but was not found.
Install it from https://brew.sh, then rerun this script.
MSG
  exit 1
fi

echo "Updating Homebrew metadata..."
brew update

echo "Ensuring HashiCorp tap exists..."
brew tap hashicorp/tap

install_formula() {
  local formula="$1"
  if brew list --formula "$formula" >/dev/null 2>&1; then
    echo "Already installed: $formula"
    return
  fi

  echo "Installing: $formula"
  brew install "$formula"
}

install_formula git
install_formula gh
install_formula jq
install_formula yq
install_formula shellcheck
install_formula pre-commit
install_formula tflint
install_formula terraform-docs
install_formula checkov
install_formula hashicorp/tap/terraform

if ! command -v op >/dev/null 2>&1; then
  echo "Installing 1Password CLI..."
  if ! brew install 1password-cli; then
    brew install --cask 1password-cli
  fi
else
  echo "Already installed: 1Password CLI"
fi

cat <<'MSG'

Bootstrap complete.

Next steps:
  1. Sign in to 1Password CLI: op signin
  2. Copy .env.1password.example to .env.1password
  3. Replace the sample op:// references with your real 1Password item fields
  4. Run: make doctor
MSG
