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

Projects:
  cobosio/cobos-io
  voltaflow/getdecant
  voltaflow/voltaflow
  voltaflow/enkiflow
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

run_terraform() {
  local dir="$1"
  shift

  require_tool terraform

  if [[ -f "$ENV_FILE" ]]; then
    require_tool op
    op run --env-file "$ENV_FILE" -- terraform -chdir="$dir" "$@"
  else
    echo "Warning: $ENV_FILE not found; running without 1Password secret loading."
    terraform -chdir="$dir" "$@"
  fi
}

doctor() {
  echo "Repository: $ROOT_DIR"
  echo "Secrets file: $ENV_FILE"

  for tool in git make terraform op gh jq; do
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
  terraform -chdir="$ROOT_DIR" fmt -recursive modules projects
}

fmt_check() {
  require_tool terraform
  terraform -chdir="$ROOT_DIR" fmt -check -recursive modules projects
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
  plan)
    dir="$(project_dir "${2:-}")"
    run_terraform "$dir" init
    run_terraform "$dir" plan
    ;;
  apply)
    dir="$(project_dir "${2:-}")"
    run_terraform "$dir" init
    run_terraform "$dir" apply
    ;;
  *)
    usage
    exit 1
    ;;
esac
