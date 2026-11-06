# Feather CMS 🪶

⚠️ ⚠️ ⚠️ !WORK IN PROGRESS! ⚠️ ⚠️ ⚠️ 

🪶 Feather is a modern Swift-based Content Management System. 

💬 Click to join the chat on [Discord](https://discord.gg/wMSkxCUXAD).

## Make Commands

See [docs/05-make-commands.md](docs/05-make-commands.md) for the repository Make targets.

## Environment Configuration

See [docs/04-environment.md](docs/04-environment.md) for environment variables and executable env files.

## Module and Backend Tests

From the repository root, start all PostgreSQL and certificate services required
by the module and backend tests:

```sh
make docker-up
```

Use `make test` for the backend package, or `make test-all` for the backend
and every package under `modules`. When finished, remove the test services, networks, and
volumes with:

```sh
make docker-down
```

## OpenAPI Generator

OpenAPI generators live in the owning module packages under `modules/`.
Use `make yaml` to regenerate module contracts.
