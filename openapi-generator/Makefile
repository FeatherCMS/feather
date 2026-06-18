SHELL := /bin/bash

baseUrl = https://raw.githubusercontent.com/BinaryBirds/github-workflows/refs/heads/main/scripts
GENERATOR_SCRIPT := ./scripts/generator.sh

.DEFAULT_GOAL := help

.PHONY: check package breakage symlinks language deps lint format docc-local run-docc docc-warnings headers fix-headers test docker-test dev png jpg help run generate generate-app generate-admin build release clean clean-all dump yaml swagger-ui

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
	docker build -t web-app-tests . -f ./docker/tests/Dockerfile && docker run --rm web-app-tests

# brew install optipng jpegoptim

dev:
	swift run Static

png:
	find ./* -type f -name '*.png' -exec optipng -o7 {} \;

jpg:
	find ./* -type f -name '*.jpg' | xargs jpegoptim --all-progressive '*.jpg'

help:
	@$(GENERATOR_SCRIPT) help

run:
	@$(GENERATOR_SCRIPT) run

generate:
	@$(GENERATOR_SCRIPT) generate

generate-app:
	@$(GENERATOR_SCRIPT) generate-app

generate-admin:
	@$(GENERATOR_SCRIPT) generate-admin

build:
	@$(GENERATOR_SCRIPT) build

release:
	@$(GENERATOR_SCRIPT) release

clean:
	@$(GENERATOR_SCRIPT) clean

clean-all:
	@$(GENERATOR_SCRIPT) clean-all

dump:
	@$(GENERATOR_SCRIPT) dump

yaml:
	@$(GENERATOR_SCRIPT) yaml

swagger-ui:
	@$(GENERATOR_SCRIPT) swagger-ui
