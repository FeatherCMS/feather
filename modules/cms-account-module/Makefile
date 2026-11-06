SHELL=/bin/bash

baseUrl = https://raw.githubusercontent.com/BinaryBirds/github-workflows/main/scripts
OPENAPI_SCRIPT := scripts/generate-openapi.sh

.PHONY: openapi openapi-yaml openapi-swift docker-openapi docker-up docker-down docker-test build test clean resolve format

openapi:
	@$(OPENAPI_SCRIPT) run

openapi-yaml:
	@$(OPENAPI_SCRIPT) yaml

openapi-swift:
	@$(OPENAPI_SCRIPT) openapi

docker-openapi:
	@docker compose up openapi-app openapi-admin

build:
	swift build

test:
	swift test --parallel

clean:
	swift package clean

resolve:
	swift package resolve

check: symlinks language deps lint headers docc-warnings package

package:
	curl -fsSL $(baseUrl)/check-swift-package.sh | bash

breakage:
	curl -fsSL $(baseUrl)/check-api-breakage.sh | bash

symlinks:
	curl -fsSL $(baseUrl)/check-broken-symlinks.sh | bash

language:
	curl -fsSL $(baseUrl)/check-unacceptable-language.sh | bash

deps:
	curl -fsSL $(baseUrl)/check-local-swift-dependencies.sh | bash

lint:
	curl -fsSL $(baseUrl)/run-swift-format.sh | bash

format:
	curl -fsSL $(baseUrl)/run-swift-format.sh | bash -s -- --fix

docc-local:
	curl -fsSL $(baseUrl)/generate-docc.sh | bash -s -- --local

run-docc:
	curl -fsSL $(baseUrl)/run-docc-docker.sh | bash

docc-warnings:
	curl -fsSL $(baseUrl)/check-docc-warnings.sh | bash

headers:
	curl -fsSL $(baseUrl)/check-swift-headers.sh | bash

fix-headers:
	curl -fsSL $(baseUrl)/check-swift-headers.sh | bash -s -- --fix

docker-up:
	docker compose up -d

docker-down:
	docker compose down --remove-orphans

docker-test:
	docker compose up --build --abort-on-container-exit --exit-code-from tests tests; \
	status=$$?; \
	docker compose down --remove-orphans; \
	exit $$status
