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
  `WEB_PUBLIC_BASE_URL=http://192.168.8.102:3456 STATIC_PUBLIC_BASE_URL=http://192.168.8.102:4567 MEDIA_PUBLIC_BASE_URL=http://192.168.8.102:8080 make all`
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

Run tests from VS Code's Test Explorer, use `make test` for the backend package,
or use `make test-all` for the backend and every package under
`modules`. When finished, remove the test services, networks, and
volumes with:

```sh
make docker-down
```

### Docker BuildKit cache error

If `make <any>` fails with `Cache export is not supported for the docker driver`,
enable **Use containerd for pulling and storing images** in Docker Desktop
Settings → General, then restart Docker Desktop and run `make <any>` again.

## Public Origin Variables

These variables control browser-facing URLs and are separate from the internal
`API_BASE_URL` used by the web app to talk to the backend service.

- `WEB_PUBLIC_BASE_URL`
  Public base URL for the web/admin app, for example `http://localhost:3456`.
- `STATIC_PUBLIC_BASE_URL`
  Public base URL for static assets, for example `http://localhost:4567`.
- `MEDIA_PUBLIC_BASE_URL`
  Public base URL for backend-served media assets, for example
  `http://localhost:8080`.

Compose defaults:

- `WEB_PUBLIC_BASE_URL=http://localhost:3456`
- `STATIC_PUBLIC_BASE_URL=http://localhost:4567`
- `MEDIA_PUBLIC_BASE_URL=http://localhost:8080`

## VS Code Workspace

When you open the FeatherCMS workspace folder in VS Code for the first time,
it may open more slowly because `"swift.searchSubfoldersForPackages": true`
searches for Swift packages in subfolders. This is expected.

## VS Code Keybindings

You can add the FeatherCMS shortcuts to VS Code's `keybindings.json` file:

1. Press `Cmd+Shift+P` to open the Command Palette.
2. Search for and select `Preferences: Open Keyboard Shortcuts (JSON)`.
3. Add these entries inside the JSON array:

```json
[
{
  "key": "cmd+ctrl+r",
  "command": "workbench.action.debug.selectandstart"
},
{
  "key": "cmd+ctrl+i",
  "command": "workbench.action.tasks.runTask",
  "args": "Ensure Local Dependencies"
},
{
  "key": "cmd+ctrl+.",
  "command": "workbench.action.debug.stop",
  "when": "inDebugMode"
},
{
  "key": "cmd+ctrl+s",
  "command": "workbench.action.tasks.runTask",
  "args": "FeatherCMS: Stop Local Runtime and Free Ports"
},
{
  "key": "cmd+ctrl+o",
  "command": "workbench.action.tasks.runTask",
  "args": "FeatherCMS: Open FeatherCMS"
}
]
```

### Development Workflow

**Before running the application, run `Ensure Local Dependencies` first. Run it only once per development session to avoid errors.**

- `cmd+ctrl+i` — Run `Ensure Local Dependencies` once per session.
- `cmd+ctrl+r` — Select and start the debug session, such as `Debug Server + Worker + WebApp + Static`.
- `cmd+ctrl+o` — Open FeatherCMS in the browser.
- `cmd+ctrl+.` — Stop the debug session while in debug mode.
- `cmd+ctrl+s` — Stop the FeatherCMS local runtime and free the ports for other applications. Run this when you finish the development session.

## OpenAPI Generator

OpenAPI generators live in the owning module packages under `modules/`.
Use `make yaml` to regenerate module contracts.
