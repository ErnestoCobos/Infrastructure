#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env.1password}"
PROJECTS=(
  "cobosio/cobos-io"
  "voltaflow/getdecant"
  "voltaflow/voltaflow"
  "voltaflow/enkiflow"
)
EXAMPLES=(
  "web-app-stack"
)

usage() {
  cat <<'MSG'
Usage:
  scripts/tf-local.sh doctor
  scripts/tf-local.sh fmt
  scripts/tf-local.sh fmt-check
  scripts/tf-local.sh init <project>
  scripts/tf-local.sh validate <project>
  scripts/tf-local.sh plan <project>
  scripts/tf-local.sh apply <project>
  scripts/tf-local.sh validate-example <example>

Projects:
  cobosio/cobos-io
  voltaflow/getdecant
  voltaflow/voltaflow
  voltaflow/enkiflow

Examples:
  web-app-stack
MSG
}

has_project() {
  local wanted="$1"
  local project
  for project in "${PROJECTS[@]}"; do
    [[ "$project" == "$wanted" ]] && return 0
  done
  return 1
}

require_tool() {
  local tool="$1"
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing required tool: $tool"
    exit 1
  fi
}

has_example() {
  local wanted="$1"
  local example
  for example in "${EXAMPLES[@]}"; do
    [[ "$example" == "$wanted" ]] && return 0
  done
  return 1
}

project_dir() {
  local project="$1"
  if ! has_project "$project"; then
    echo "Unknown project: $project"
    usage
    exit 1
  fi

  local dir="$ROOT_DIR/projects/$project"
  if [[ ! -d "$dir" ]]; then
    echo "Project directory does not exist: $dir"
    exit 1
  fi

  printf '%s\n' "$dir"
}

example_dir() {
  local example="$1"
  if ! has_example "$example"; then
    echo "Unknown example: $example"
    usage
    exit 1
  fi

  local dir="$ROOT_DIR/examples/$example"
  if [[ ! -d "$dir" ]]; then
    echo "Example directory does not exist: $dir"
    exit 1
  fi

  printf '%s\n' "$dir"
}

run_terraform() {
  local dir="$1"
  shift

  require_tool terraform

  if [[ -f "$ENV_FILE" ]]; then
    require_tool op
    op run --env-file "$ENV_FILE" -- terraform -chdir="$dir" "$@"
  else
    if [[ "${REQUIRE_1PASSWORD:-0}" == "1" && "${ALLOW_AMBIENT_CREDENTIALS:-0}" != "1" ]]; then
      echo "Missing required 1Password env file: $ENV_FILE"
      echo "Copy .env.1password.example to .env.1password, or set ALLOW_AMBIENT_CREDENTIALS=1 if you intentionally want ambient credentials."
      exit 1
    fi

    echo "Warning: $ENV_FILE not found; running without 1Password secret loading."
    terraform -chdir="$dir" "$@"
  fi
}

run_terraform_with_secrets() {
  local dir="$1"
  shift

  REQUIRE_1PASSWORD=1 run_terraform "$dir" "$@"
}

doctor() {
  echo "Repository: $ROOT_DIR"
  echo "Secrets file: $ENV_FILE"

  for tool in git make terraform op gh jq vercel supabase shellcheck; do
    if command -v "$tool" >/dev/null 2>&1; then
      printf '%-12s %s\n' "$tool" "$(command -v "$tool")"
    else
      printf '%-12s missing\n' "$tool"
    fi
  done

  if [[ -f "$ENV_FILE" ]]; then
    echo "1Password env file: present"
  else
    echo "1Password env file: missing; copy .env.1password.example to .env.1password"
  fi
}

fmt_all() {
  require_tool terraform
  terraform -chdir="$ROOT_DIR" fmt -recursive modules projects examples
}

fmt_check() {
  require_tool terraform
  terraform -chdir="$ROOT_DIR" fmt -check -recursive modules projects examples
}

cmd="${1:-}"
case "$cmd" in
  doctor)
    doctor
    ;;
  fmt)
    fmt_all
    ;;
  fmt-check)
    fmt_check
    ;;
  init)
    dir="$(project_dir "${2:-}")"
    run_terraform "$dir" init
    ;;
  validate)
    dir="$(project_dir "${2:-}")"
    run_terraform "$dir" init -backend=false
    run_terraform "$dir" validate
    ;;
  validate-example)
    dir="$(example_dir "${2:-}")"
    run_terraform "$dir" init -backend=false
    run_terraform "$dir" validate
    ;;
  plan)
    dir="$(project_dir "${2:-}")"
    run_terraform_with_secrets "$dir" init
    run_terraform_with_secrets "$dir" plan
    ;;
  apply)
    dir="$(project_dir "${2:-}")"
    run_terraform_with_secrets "$dir" init
    run_terraform_with_secrets "$dir" apply
    ;;
  *)
    usage
    exit 1
    ;;
esac
