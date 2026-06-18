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
- `make backend`
  Builds and runs the backend stack: dependencies plus `server` and `worker`.
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
- `make clean backend`
  Clears database and media storage, then builds and runs the backend stack.

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

## Todos

- [ ] hook functions for modules -> asset deletion should trigger hook (remove related assets)
- [ ] email template system -> send out emails
- [ ] content editor for web-based contents
- [ ] required relations, autocomplete fixes (require N item)
- [ ] multiple selection for gallery picker -> video picker, file picker, etc.
- [ ] review migrations
- [ ] fix required labels design
- [ ] split openapi into modules
- [ ] cleanup css setAttribute calls
- [ ] review architecture boundaries (frontend, backend)

## OpenAPI Generator

The Swift OpenAPI generator package lives at `openapi-generator`.
Use `make -C openapi-generator yaml` or `make -C openapi-generator run`
to regenerate the OpenAPI YAML and generated Swift sources in
`openapi`.
