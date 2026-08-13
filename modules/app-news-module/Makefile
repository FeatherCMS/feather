SHELL := /bin/bash

baseUrl = https://raw.githubusercontent.com/BinaryBirds/github-workflows/main/scripts
OPENAPI_SCRIPT := scripts/generate-openapi.sh

.PHONY: openapi openapi-yaml openapi-swift docker-openapi build test clean resolve format

openapi:
	@$(OPENAPI_SCRIPT) run

openapi-yaml:
	@$(OPENAPI_SCRIPT) yaml

openapi-swift:
	@$(OPENAPI_SCRIPT) openapi

docker-openapi:
	@bash scripts/download-swagger.sh
	@docker compose up --build openapi-app openapi-admin

build:
	swift build

test:
	swift test --parallel

clean:
	swift package clean

resolve:
	swift package resolve

format:
	curl -fsSL $(baseUrl)/run-swift-format.sh | bash -s -- --fix
