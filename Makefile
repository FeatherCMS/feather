SHELL := /bin/bash

COMPOSE := docker compose -f docker-compose.yaml
MODULE_DIRS := $(sort $(patsubst %/,%,$(dir $(wildcard modules/*/Package.swift))))
DOCKER_MODULE_DIRS := feather-core $(MODULE_DIRS)
OPENAPI_MODULE_DIRS := $(MODULE_DIRS)
TEST_PACKAGE_DIRS := application $(MODULE_DIRS)
FORMAT_PACKAGE_DIRS := feather-core application $(MODULE_DIRS)
DEPS_SERVICES := certificates postgres migrator
APPLICATION_SERVICES := $(DEPS_SERVICES) server worker web-static openapi-app openapi-admin web-app
APPLICATION_RUNTIME_SERVICES := migrator server worker web-static web-app
NON_APPLICATION_SERVICES := certificates postgres openapi-app openapi-admin
APPLICATION_ARTIFACT_IMAGE := feather-cms-application-artifacts
APPLICATION_CACHE := .docker-cache/application
ALL_SERVICES := certificates postgres migrator server worker web-static openapi-app openapi-admin web-app
POSTGRES_VOLUME := feather-cms-postgres-data
MEDIA_VOLUME := feather-cms-file-storage

.PHONY: up up-build down stop logs ps restart pull config clean reset deps all application application-artifacts application-images application-logs test test-all format fix-headers docker-up docker-down docker-clean yaml $(APPLICATION_RUNTIME_SERVICES) $(NON_APPLICATION_SERVICES) $(SERVICE_TARGETS)

define detect_lan_host
iface="$$(route -n get default 2>/dev/null | awk '/interface: / { print $$2; exit }')"; \
if [ -n "$$iface" ]; then \
	ip="$$(ipconfig getifaddr "$$iface" 2>/dev/null || true)"; \
fi; \
if [ -z "$$ip" ]; then \
	ip="$$(ifconfig | awk '/inet (192\.168\.|10\.|172\.(1[6-9]|2[0-9]|3[0-1])\.)/ { print $$2; exit }')"; \
fi; \
printf '%s' "$$ip"
endef

define run_all_services_with_public_origins
@$(MAKE) application-images
@$(COMPOSE) build $(NON_APPLICATION_SERVICES)
@LAN_HOST="$${LAN_HOST:-$$($(detect_lan_host))}"; \
if [ -n "$$LAN_HOST" ]; then \
	echo "Using LAN host $$LAN_HOST for public origins"; \
	WEB_PUBLIC_BASE_URL="$${WEB_PUBLIC_BASE_URL:-http://$$LAN_HOST:3456}" \
	STATIC_PUBLIC_BASE_URL="$${STATIC_PUBLIC_BASE_URL:-http://$$LAN_HOST:4567}" \
	MEDIA_PUBLIC_BASE_URL="$${MEDIA_PUBLIC_BASE_URL:-http://$$LAN_HOST:8080}" \
	$(COMPOSE) up $(ALL_SERVICES); \
else \
	echo "LAN host detection failed, using configured/default public origins"; \
	$(COMPOSE) up $(ALL_SERVICES); \
fi
endef

up:
	$(COMPOSE) up

up-build:
	$(MAKE) application-images
	$(COMPOSE) build $(NON_APPLICATION_SERVICES)
	$(COMPOSE) up

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

restart:
	$(COMPOSE) restart

pull:
	$(COMPOSE) pull

config:
	$(COMPOSE) config

clean:
	$(COMPOSE) down --remove-orphans
	docker volume rm -f $(POSTGRES_VOLUME) $(MEDIA_VOLUME) 2>/dev/null || true

reset:
	$(COMPOSE) down --remove-orphans --volumes

deps:
	$(MAKE) application-artifacts
	$(COMPOSE) build migrator
	$(COMPOSE) up -d certificates postgres migrator

test:
	$(MAKE) -C application test

test-all:
	@set -e; \
	for package in $(TEST_PACKAGE_DIRS); do \
		echo "Testing $$package"; \
		if [ -f "$$package/Makefile" ]; then \
			$(MAKE) -C "$$package" test; \
		else \
			(cd "$$package" && swift test --parallel); \
		fi; \
		done

format:
	@set -e; \
	for package in $(FORMAT_PACKAGE_DIRS); do \
		echo "Formatting $$package"; \
		$(MAKE) -C "$$package" format; \
	done

docker-up:
	$(COMPOSE) up -d certificates postgres
	@set -e; \
	for module in $(DOCKER_MODULE_DIRS); do \
		$(MAKE) -C $$module docker-up; \
	done

docker-down:
	@set -e; \
	for module in $(DOCKER_MODULE_DIRS); do \
		$(MAKE) -C $$module docker-down; \
	done
	$(COMPOSE) down -v --remove-orphans

docker-clean:
	docker builder prune --filter "type=exec.cachemount" -f

yaml:
	@set -e; \
	for module in $(OPENAPI_MODULE_DIRS); do \
		$(MAKE) -C $$module openapi-yaml; \
	done

all:
	$(run_all_services_with_public_origins)

application:
	$(MAKE) application-images
	$(COMPOSE) up $(APPLICATION_SERVICES)

application-artifacts:
	docker buildx build \
		--file ./docker/application/Dockerfile \
		--target application-artifacts \
		--tag $(APPLICATION_ARTIFACT_IMAGE) \
		--network host \
		--load \
		--cache-from type=local,src=$(APPLICATION_CACHE) \
		--cache-to type=local,dest=$(APPLICATION_CACHE),mode=max \
		.

application-images: application-artifacts
	$(COMPOSE) build $(APPLICATION_RUNTIME_SERVICES)

application-logs:
	$(COMPOSE) logs -f migrator server worker web-static openapi-app openapi-admin

$(APPLICATION_RUNTIME_SERVICES):
	$(MAKE) application-artifacts
	$(COMPOSE) build $@
	$(COMPOSE) up $@

$(NON_APPLICATION_SERVICES):
	$(COMPOSE) up --build $@
