SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

PROJECT ?= cobosio/cobos-io
PROJECTS := cobosio/cobos-io voltaflow/getdecant voltaflow/voltaflow voltaflow/enkiflow
EXAMPLES := web-app-stack
TF_LOCAL := ./scripts/tf-local.sh

.PHONY: help bootstrap-macos doctor fmt fmt-check init validate plan apply ci validate-all validate-examples plan-all

help: ## Show available commands.
	@awk 'BEGIN {FS = ":.*## "}; /^[a-zA-Z0-9_-]+:.*## / {printf "%-18s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

bootstrap-macos: ## Install macOS prerequisites.
	./scripts/bootstrap-macos.sh

doctor: ## Check local tools and secret wiring.
	$(TF_LOCAL) doctor

fmt: ## Format all Terraform files.
	$(TF_LOCAL) fmt

fmt-check: ## Check Terraform formatting.
	$(TF_LOCAL) fmt-check

init: ## Initialize one Terraform project. Usage: make init PROJECT=cobosio/cobos-io
	$(TF_LOCAL) init "$(PROJECT)"

validate: ## Validate one Terraform project.
	$(TF_LOCAL) validate "$(PROJECT)"

plan: ## Plan one Terraform project.
	$(TF_LOCAL) plan "$(PROJECT)"

apply: ## Apply one Terraform project manually.
	$(TF_LOCAL) apply "$(PROJECT)"

ci: fmt-check validate-all validate-examples ## Run local CI checks.

validate-all: ## Validate every Terraform project.
	@for project in $(PROJECTS); do \
		echo "==> validate $$project"; \
		$(TF_LOCAL) validate "$$project"; \
	done

validate-examples: ## Validate Terraform examples.
	@for example in $(EXAMPLES); do \
		echo "==> validate example $$example"; \
		$(TF_LOCAL) validate-example "$$example"; \
	done

plan-all: ## Plan every Terraform project manually.
	@for project in $(PROJECTS); do \
		echo "==> plan $$project"; \
		$(TF_LOCAL) plan "$$project"; \
	done
