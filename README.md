# Feather CMS 🪶

⚠️ ⚠️ ⚠️ !WORK IN PROGRESS! ⚠️ ⚠️ ⚠️ 

🪶 Feather is a modern Swift-based Content Management System. 

💬 Click to join the chat on [Discord](https://discord.gg/wMSkxCUXAD).

## Make Commands

Run these from the repository root:

- `make clean`
  Clears only the Postgres database volume and media storage volume.
- `make reset`
  Drops the full Compose stack, including all Compose-managed volumes.
- `make stop`
  Stops all running services without removing them.
- `make deps`
  Builds and runs the current dependency services: `certificates`, `postgres`, and `migrator`.
- `make application`
  Builds the shared application artifact image once, builds the runtime images
  from it, and runs the application stack: dependencies, migrations, backend
  workers, web app, static server, and OpenAPI services.
- `make local`
  Runs PostgreSQL in Docker and runs the migrator, backend server, worker, web
  app, and static server as local Swift processes. Local media is stored in
  `.docker/media`.
- `make local-app`
  Builds and runs only the local `WebApp` executable.
- `make local-backend`
  Runs PostgreSQL in Docker and runs the migrator, backend server, and worker
  locally, without starting the web app or static server.
- `make application-artifacts`
  Compiles all application executables once and creates the local artifact
  image used by the runtime images.
- `make application-images`
  Builds the artifact image and the separate minimal runtime images.
- `make all`
  Builds and runs the full local stack.
  For the web app, this also sets browser-facing public origins for:
  `WEB_PUBLIC_BASE_URL`, `STATIC_PUBLIC_BASE_URL`, and `MEDIA_PUBLIC_BASE_URL`.
  By default, `make all` and `make all-up` try to detect the current LAN IP and
  use:
  `http://<ip>:3456`, `http://<ip>:4567`, and `http://<ip>:8080`.
  If LAN detection fails, Compose falls back to the localhost defaults.
  You can override any of them explicitly, for example:
  `WEB_PUBLIC_BASE_URL=http://192.168.8.102:3456 STATIC_PUBLIC_BASE_URL=http://192.168.8.102:4567 MEDIA_PUBLIC_BASE_URL=http://192.168.8.102:9000/feather-cms-app make all`
- `make clean all`
  Clears database and media storage, then builds and runs the full stack.
- `make clean application`
  Clears database and media storage, then builds and runs the application stack.


## Amazon SES Configuration

The worker sends email through Amazon SES. Keep credentials in a local `.env`
file next to `docker-compose.yaml`; `.env` files are ignored by Git.

```env
SES_ID=your-aws-access-key-id
SES_SECRET=your-aws-secret-access-key
SES_REGION=eu-central-1
```

Start the services with:

```bash
docker compose up --build
```

### Module and Backend Tests

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

### Docker BuildKit cache error

If `make <any>` fails with `Cache export is not supported for the docker driver`,
enable **Use containerd for pulling and storing images** in Docker Desktop
Settings → General, then restart Docker Desktop and run `make <any>` again.

## Worker Media Processing

The worker keeps its general job concurrency at `WORKER_NUM_WORKERS` (16 by
default), while ImageMagick/FFmpeg asset processing is limited separately by
`MEDIA_MAX_CONCURRENT_PROCESSING` (1 by default). Duplicate media jobs for the
same asset are ignored while that asset is already being processed. Media jobs
waiting for a processing slot still occupy worker handlers, so a large media
backlog can temporarily reduce capacity for other job types.

## Public Origin Variables

These variables control browser-facing URLs and are separate from the internal
`API_BASE_URL` used by the web app to talk to the backend service.

- `WEB_PUBLIC_BASE_URL`
  Public base URL for the web/admin app, for example `http://localhost:3456`.
- `STATIC_PUBLIC_BASE_URL`
  Public base URL for static assets, for example `http://localhost:4567`.
- `MEDIA_PUBLIC_BASE_URL`
  Public base URL for backend-served media assets, for example
  `http://localhost:9000/feather-cms-app` in the Compose stack.

The WebApp uses all three public origins plus `API_BASE_URL`. Worker and
Migrator each read `WEB_PUBLIC_BASE_URL` for links and migration events. Server
uses `MEDIA_PUBLIC_BASE_URL`; WebStatic only needs its HTTP listener settings.

Each executable loads its own environment file by default:
`server.<environment>.env`, `web-app.<environment>.env`,
`static.<environment>.env`, `worker.<environment>.env`, and
`migrator.<environment>.env`. The environment defaults to `dev`; pass
`--env stage` (or another supported environment) to select a different file.
Use `--env-file-path` to provide an explicit file. Example files are in
`application/configs/`.

Compose defaults:

- `WEB_PUBLIC_BASE_URL=http://localhost:3456`
- `STATIC_PUBLIC_BASE_URL=http://localhost:4567`
- `MEDIA_PUBLIC_BASE_URL=http://localhost:9000/feather-cms-app`

## OpenAPI Generator

OpenAPI generators live in the owning module packages under `modules/`.
Use `make yaml` to regenerate module contracts.
