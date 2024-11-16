.DEFAULT_GOAL := help
SHELL := /usr/bin/env bash
.SHELLFLAGS := -eu -o pipefail -c
ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

IMAGE := devodev/bambulabs-exporter
VERSION ?= 0.1.0

LONG_TAG  := $(subst $(eval) ,.,$(wordlist 1,3,$(subst ., ,$(VERSION:%=%))))
SHORT_TAG := $(subst $(eval) ,.,$(wordlist 1,2,$(subst ., ,$(VERSION:%=%))))
TAGS := $(LONG_TAG) $(SHORT_TAG) latest

DOCKER_COMPOSE := docker-compose -f $(ROOT_DIR)/docker/docker-compose.yaml

##@ Docker

build: ## Build docker image.
	@docker build -f $(ROOT_DIR)/docker/Dockerfile $(TAGS:%=-t $(IMAGE):%) $(ROOT_DIR)

push: build ## Push docker image.
	@$(TAGS:%=docker push $(IMAGE):%;)

compose-up: ## Start docker compose stack detached.
	@$(DOCKER_COMPOSE) up -d

compose-logs: ## Tail logs of docker compose stack.
	@$(DOCKER_COMPOSE) logs -f

compose-stop: ## Stop docker compose stack.
	@$(DOCKER_COMPOSE) stop

compose-down: ## Destroy docker compose stack.
	@$(DOCKER_COMPOSE) down --volumes
	@docker rmi bambulabs-exporter:compose

##@ Go

gofmt: ## Run gofmt on Go source files in the repository.
	@echo running gofmt on all packages...
	go fmt ./...

govet: ## Run govet on Go source files in the repository.
	@echo vetting all packages...
	go vet ./...

##@ Helpers

print-%: ## Print a var
	@echo $($*)

help: ## Display help for the Makefile.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9][a-zA-Z0-9 _-]*:.*?##/ { split($$1, targets, " "); for (i in targets) { printf "  \033[36m%-28s\033[0m %s\n", targets[i], $$2 } } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: build push compose-up compose-stop compose-down gofmt govet print-% help
