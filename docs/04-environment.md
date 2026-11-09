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
| `MEDIA_PUBLIC_BASE_URL` | Browser requests for backend-served media | `http://feather-media.localhost.floci.io:4566` |
| `API_BASE_URL` | WebApp requests to the backend Server | `http://server:8080` in Compose; `http://localhost:8080` locally |

The Compose stack starts Floci on port `4566` for S3, SES, and CloudFront-compatible media delivery. The local media edge is `http://feather-media.localhost.floci.io:4566`; Floci creates the bucket, verifies the local sender, and provisions the distribution and URI-rewrite function on startup. `make all` attempts to detect a LAN address and uses a `nip.io` alias for media delivery from other devices. Set `MEDIA_CLOUDFRONT_ALIAS` and `MEDIA_PUBLIC_BASE_URL` together when overriding that host; see [Make commands](05-make-commands.md).

## Worker media processing

`WORKER_NUM_WORKERS` controls general job concurrency and defaults to `16`. `MEDIA_MAX_CONCURRENT_PROCESSING` separately limits ImageMagick/FFmpeg media processing and defaults to `1`. Media jobs waiting for a processing slot still occupy worker handlers, so a large media backlog can temporarily reduce capacity for other job types.

## Amazon SES

The worker sends email through Amazon SES v2. The Compose stack points it at Floci, which captures messages locally at `http://localhost:4566/_aws/ses`. The local default sender identity is `no-reply@feather.local`; set `SES_FROM_EMAIL` to another sender if needed. Floci verifies an email identity when it is created.

```env
SES_REGION=eu-central-1
SES_ENDPOINT=http://floci:4566
SES_FROM_EMAIL=no-reply@feather.local
```

Server and Worker use Soto's default credential provider for every AWS service. Compose supplies placeholder `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` values solely for local Floci requests; `scripts/run-local.sh` sets the same local values for host processes. For AWS deployments, leave credentials out of the application configuration and use an instance role or another AWS credential provider. Native production deployments leave `SES_ENDPOINT` empty to use AWS SES.
