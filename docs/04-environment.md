# Environment configuration

Feather loads settings separately for each executable. The executable owns its config type and loader; environment variables and that executable's env file supply its values.

## Executable env files

The loader defaults to the `dev` environment and looks for `<executable>.<environment>.env` in the process working directory. Pass `--env stage` to select another environment, or `--env-file-path <path>` to load a specific file.

Example files are checked in under `application/configs/`:

| Example file | Executable | Default env filename |
| --- | --- | --- |
| `server.example.env` | Server | `server.dev.env` |
| `migrator.example.env` | Migrator | `migrator.dev.env` |
| `worker.example.env` | Worker | `worker.dev.env` |
| `web-app.example.env` | WebApp | `web-app.dev.env` |
| `web-static.example.env` | WebStatic | `web-static.dev.env` |

The `.example.env` files are examples, not automatically loaded defaults. Either create the expected env file in the process working directory or pass the example file with `--env-file-path`.

## Public origins

Browser-facing public URLs are separate from the internal `API_BASE_URL` that WebApp uses to call Server.

| Variable | Used by | Example |
| --- | --- | --- |
| `WEB_PUBLIC_BASE_URL` | WebApp and Worker/Migrator links | `http://localhost:3456` |
| `STATIC_PUBLIC_BASE_URL` | Browser requests for static assets | `http://localhost:4567` |
| `MEDIA_PUBLIC_BASE_URL` | Browser requests for backend-served media | `http://localhost:9000/feather-cms-app` |
| `API_BASE_URL` | WebApp requests to the backend Server | `http://server:8080` in Compose; `http://localhost:8080` locally |

In the Compose stack, the public-origin defaults are `http://localhost:3456`, `http://localhost:4567`, and `http://localhost:9000/feather-cms-app`. `make all` attempts to detect a LAN address and use it for browser-facing origins. Set the variables explicitly when the defaults do not fit your setup; see [Make commands](05-make-commands.md).

## Worker media processing

`WORKER_NUM_WORKERS` controls general job concurrency and defaults to `16`. `MEDIA_MAX_CONCURRENT_PROCESSING` separately limits ImageMagick/FFmpeg media processing and defaults to `1`. Media jobs waiting for a processing slot still occupy worker handlers, so a large media backlog can temporarily reduce capacity for other job types.

## Amazon SES

The worker sends email through Amazon SES. For the Compose stack, keep these credentials in a local `.env` file beside `docker-compose.yaml`; Git ignores `.env` files.

```env
SES_ID=your-aws-access-key-id
SES_SECRET=your-aws-secret-access-key
SES_REGION=eu-central-1
```

Start the Compose services with `docker compose up --build` or use the repository targets documented in [Make commands](05-make-commands.md).
