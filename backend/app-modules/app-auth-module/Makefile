SHELL=/bin/bash

baseUrl = https://raw.githubusercontent.com/BinaryBirds/github-workflows/refs/heads/main/scripts
certVolume ?= app_auth_module_certificates
certOutputDir ?= .docker/certs
certOutputFile ?= $(certOutputDir)/ca.pem

check: symlinks language deps lint headers docc-warnings package

package:
	curl -s $(baseUrl)/check-swift-package.sh | bash

breakage:
	curl -s $(baseUrl)/check-api-breakage.sh | bash

symlinks:
	curl -s $(baseUrl)/check-broken-symlinks.sh | bash

language:
	curl -s $(baseUrl)/check-unacceptable-language.sh | bash

deps:
	curl -s $(baseUrl)/check-local-swift-dependencies.sh | bash

lint:
	curl -s $(baseUrl)/run-swift-format.sh | bash

format:
	curl -s $(baseUrl)/run-swift-format.sh | bash -s -- --fix

docc-local:
	curl -s $(baseUrl)/generate-docc.sh | bash -s -- --local

run-docc:
	curl -s $(baseUrl)/run-docc-docker.sh | bash

docc-warnings:
	curl -s $(baseUrl)/check-docc-warnings.sh | bash

headers:
	curl -s $(baseUrl)/check-swift-headers.sh | bash

fix-headers:
	curl -s $(baseUrl)/check-swift-headers.sh | bash -s -- --fix

test:
	swift test --parallel

docker-test:
	docker build -t app-auth-module-tests . -f ./docker/tests/Dockerfile && docker run --rm app-auth-module-tests

export-postgres-ca:
	mkdir -p $(certOutputDir)
	docker run --rm \
		-v $(certVolume):/from \
		-v $(PWD)/$(certOutputDir):/to \
		alpine sh -c 'cp /from/ca.pem /to/ca.pem'
	@echo "Exported CA certificate to: $(certOutputFile)"
