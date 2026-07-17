SHELL=/bin/bash

baseUrl = https://raw.githubusercontent.com/BinaryBirds/github-workflows/main/scripts
certVolume ?= app_redirect_module_certificates
certOutputDir ?= .docker/certs
certOutputFile ?= $(certOutputDir)/ca.pem

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

test:
	swift test --parallel

docker-up:
	docker compose up -d certificates postgres

docker-down:
	docker compose down -v --remove-orphans

docker-test:
	docker compose up --build --abort-on-container-exit --exit-code-from tests tests; \
	status=$$?; \
	docker compose down -v --remove-orphans; \
	exit $$status

export-postgres-ca:
	mkdir -p $(certOutputDir)
	docker run --rm \
		-v $(certVolume):/from \
		-v $(PWD)/$(certOutputDir):/to \
		alpine sh -c 'cp /from/ca.pem /to/ca.pem'
	@echo "Exported CA certificate to: $(certOutputFile)"
