# Make commands

Run these commands from the repository root. For environment variables used by the runtime, see [environment configuration](04-environment.md).

## Start and stop services

| Command | What it does |
| --- | --- |
| `make up` | Starts the Compose services using existing images. |
| `make up-build` | Builds application and support images, then starts the Compose stack. |
| `make application` | Builds the application images and starts the application services. |
| `make deps` | Builds the application artifact and starts certificates, PostgreSQL, and the migrator. |
| `make stop` | Stops running Compose services without removing them. |
| `make down` | Removes Compose services and networks; keeps named volumes. |
| `make reset` | Removes the Compose stack and all Compose-managed volumes. |

`make all` builds and starts the full stack. It attempts to detect the current LAN IP and uses it for browser-facing public origins. If detection fails, Compose uses the configured defaults. Set `LAN_HOST` or the public origin variables explicitly when needed; see [environment configuration](04-environment.md).

For local Swift processes with PostgreSQL in Docker:

- `make local` runs the migrator, server, worker, WebApp, and WebStatic.
- `make local-backend` runs the migrator, server, and worker without the web services.
- `make local-app` runs only the WebApp executable.

`make application-artifacts` builds the shared application artifact image. `make application-images` then builds the separate runtime images. Use `make application-logs` to follow logs from the application services.

## Clean data and build cache

- `make clean` removes the Compose services and the Postgres and MinIO data volumes.
- `make reset` removes all Compose-managed volumes, including volumes not removed by `make clean`.
- `make docker-clean` prunes Docker BuildKit exec cache mounts.

If a build fails with `Cache export is not supported for the docker driver`, enable **Use containerd for pulling and storing images** in Docker Desktop Settings → General, restart Docker Desktop, and retry the build.

## Tests and OpenAPI

- `make test` runs the application package tests.
- `make test-all` runs tests for `application` and every package under `modules`.
- `make docker-up` starts the test dependencies and module test services.
- `make docker-down` removes the module test services and all root Compose volumes, including Postgres and MinIO data.
- `make yaml` regenerates module OpenAPI YAML documents.
- `make yaml-swift` regenerates generated Swift API sources from those documents.

Run module-specific generation targets from the module directory. See each module's `Makefile` for `openapi`, `openapi-yaml`, and `openapi-swift` behavior.
