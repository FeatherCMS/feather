SHELL := /bin/bash

COMPOSE := docker compose -f docker-compose.yaml
DEPS_SERVICES := certificates postgres migrator
BACKEND_SERVICES := $(DEPS_SERVICES) server worker
ALL_SERVICES := certificates postgres migrator server worker web-static openapi-app openapi-admin web-app
POSTGRES_VOLUME := feather-cms-postgres-data
MEDIA_VOLUME := feather-cms-file-storage

.PHONY: up up-build down stop logs ps restart pull config clean reset deps all backend all-up backend-up backend-logs backend-down backend-rebuild web-static-rebuild clean-backend

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
@LAN_HOST="$${LAN_HOST:-$$($(detect_lan_host))}"; \
if [ -n "$$LAN_HOST" ]; then \
	echo "Using LAN host $$LAN_HOST for public origins"; \
	WEB_PUBLIC_BASE_URL="$${WEB_PUBLIC_BASE_URL:-http://$$LAN_HOST:3456}" \
	STATIC_PUBLIC_BASE_URL="$${STATIC_PUBLIC_BASE_URL:-http://$$LAN_HOST:4567}" \
	MEDIA_PUBLIC_BASE_URL="$${MEDIA_PUBLIC_BASE_URL:-http://$$LAN_HOST:8080}" \
	$(COMPOSE) up --build $(ALL_SERVICES); \
else \
	echo "LAN host detection failed, using configured/default public origins"; \
	$(COMPOSE) up --build $(ALL_SERVICES); \
fi
endef

up:
	$(COMPOSE) up

up-build:
	$(COMPOSE) up --build

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
	$(COMPOSE) up --build $(DEPS_SERVICES)

all:
	$(run_all_services_with_public_origins)

all-up:
	$(run_all_services_with_public_origins)

backend:
	$(COMPOSE) up --build $(BACKEND_SERVICES)

backend-up:
	$(COMPOSE) up --build $(BACKEND_SERVICES)

backend-logs:
	$(COMPOSE) logs -f migrator server worker web-static openapi-app openapi-admin

backend-down:
	$(COMPOSE) down --remove-orphans

backend-rebuild:
	$(COMPOSE) build --no-cache $(BACKEND_SERVICES)
	$(COMPOSE) up $(BACKEND_SERVICES)

web-static-rebuild:
	$(COMPOSE) build --no-cache web-static
	$(COMPOSE) up web-static

clean-backend:
	$(MAKE) clean backend
