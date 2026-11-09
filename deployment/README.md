# Feather native Linux deployment

This deployment runs the Swift executables directly under systemd.

## Ubuntu 26.04 runtime packages

Install the packages required by the Worker runtime:

```sh
sudo apt update

sudo apt install -y \
    ca-certificates \
    ffmpeg \
    ghostscript \
    imagemagick

sudo apt install -y \
    postgresql \
    postgresql-contrib
```

These packages provide the media-processing tools used by the Worker. The
default release build statically links the Swift standard library, so Swift
does not need to be installed on the runtime host.

## Runtime layout

Install the output of `./deployment/dist.sh --release` at `/opt/feather`:

```text
/opt/feather/backend/Server
/opt/feather/backend/Migrator
/opt/feather/backend/Worker
/opt/feather/web-app/WebApp
/opt/feather/web-app/*.resources
/opt/feather/web-app/*.bundle
/opt/feather/web-static/WebStatic
/opt/feather/web-static/public/
# Only present when --shared-swift-runtime is used:
/opt/feather/swift-runtime/*.so*
```

Build on the Linux deployment host, or build on a matching Linux machine.
Native macOS executables cannot run on Linux.

From the repository root on that Linux machine:

```sh
./deployment/dist.sh --release
```

The distribution build statically links the Swift standard library so the
executables do not depend on systemd finding Swift runtime libraries such as
`libswiftSwiftOnoneSupport.so`.

For a development deployment, use `./deployment/dist.sh --debug` instead.

To build without statically linking Swift's standard library, use:

```sh
./deployment/dist.sh --release --shared-swift-runtime
```

This copies the Swift shared libraries from the build host into
`dist/swift-runtime`. The deployment script installs them at
`/opt/feather/swift-runtime`; the systemd units set `LD_LIBRARY_PATH` for
the `feather` service user, so no Swift installation is required at
runtime.

After the initial service-account and configuration setup below, rebuild and
deploy the complete native distribution from the repository root. The script
stops the Feather services first, preserves an already-edited `dist/feather.env`,
installs the new files and systemd units, then starts every service except
Migrator:

```sh
./deployment/deploy.sh --release
```

For shared Swift runtime deployment:

```sh
./deployment/deploy.sh --release --shared-swift-runtime
```

To deploy the existing `dist/` without rebuilding:

```sh
./deployment/deploy.sh --no-build
```

Create the service account and runtime directories:

```sh
sudo useradd --system --home-dir /opt/feather --shell /usr/sbin/nologin feather
sudo install -d -o feather -g feather /opt/feather
sudo install -d -o root -g feather -m 0750 /etc/feather
cp deployment/.env.example .env
# Edit .env and replace all placeholders before installing it.
sudo install -o root -g feather -m 0640 .env /etc/feather/feather.env
```

Edit the deployed configuration later with:

```sh
sudoedit /etc/feather/feather.env
```

## S3-compatible media storage

The native services use the S3-compatible storage configured by
`STORAGE_S3_*`. The local Docker Compose stack runs Floci for S3, SES, and
CloudFront-compatible media delivery; see the [local environment guide](../docs/04-environment.md).
The native systemd deployment does not run Floci; configure an existing
private S3-compatible bucket. Leave
`STORAGE_S3_ENDPOINT` empty for AWS S3, or set it to the complete endpoint URL
for another provider.

When deploying Feather on AWS EC2, attach an IAM role with the required S3
permissions. The AWS default credential chain uses the instance role. Outside
EC2, configure another provider supported by the AWS default credential chain.

Example environment values for a Feather deployment:

```dotenv
STORAGE_S3_REGION=eu-central-1
STORAGE_S3_ENDPOINT=
STORAGE_S3_BUCKET=feather-cms-app
MEDIA_PUBLIC_BASE_URL=https://media.feathercms.com
SES_ENDPOINT=
STORAGE_OBJECT_KEY_DEPTH=2
STORAGE_OBJECT_KEY_SEGMENT_LENGTH=2
```

Never put real credentials in this repository, `dist/feather.env`, or
deployment logs. Server and Worker need object read/write/delete and bucket
listing permissions, including the required multipart-upload operations.
The Worker uses `SES_ENDPOINT` only for an SES-compatible local endpoint; leave
it empty in production to use AWS SES. Attach an IAM role with SES send
permissions to the EC2 instance.

## PostgreSQL backups

On the live host, install AWS CLI and the backup script and cron entry:

```sh
sudo apt install -y awscli
sudo install -o root -g root -m 0750 \
    deployment/scripts/feather-postgresql-backup \
    /usr/local/sbin/feather-postgresql-backup
sudo install -o root -g root -m 0644 \
    deployment/cron/feather-postgresql-backup.cron \
    /etc/cron.d/feather-postgresql-backup
```

The cron entry runs daily at 02:00 UTC. The script reads the live PostgreSQL
connection settings from `/etc/feather/feather.env`, creates a root-only plain
SQL dump, and uploads it to the private `feather-backups` bucket in
`eu-central-1` at `live/YYYY/MM/DD/backup.sql`. It prevents overlapping runs
and removes its local temporary dump after upload. If the S3 upload fails,
the completed SQL dump is retained in `/var/backups/feather/failed/` with
root-only permissions for retry. The EC2 instance role must allow
`s3:PutObject` on `arn:aws:s3:::feather-backups/live/*`; the bucket's
default encryption is used. Retained failed backups are not automatically
pruned; remove them after successfully retrying the upload.

Run a backup immediately to verify the setup:

```sh
sudo /usr/local/sbin/feather-postgresql-backup
```

### S3 media bucket archive

To also create a daily compressed archive of the current objects in the live
media bucket, install the script and cron entry:

```sh
sudo install -o root -g root -m 0750 \
    deployment/scripts/feather-s3-bucket-backup \
    /usr/local/sbin/feather-s3-bucket-backup
sudo install -o root -g root -m 0644 \
    deployment/cron/feather-s3-bucket-backup.cron \
    /etc/cron.d/feather-s3-bucket-backup
```

This runs daily at 03:00 UTC and uploads the archive to
`s3://feather-backups/live/YYYY/MM/DD/s3.tar.gz`. It stages the bucket's
current objects under `/var/tmp`, creates and validates a gzip level 1 tar
archive, uploads it, then removes the temporary files. It does not include
bucket configuration or noncurrent object versions. The EC2 instance role
needs `s3:ListBucket` and `s3:GetObject` on `feather-cms-app`, plus
`s3:PutObject` on `feather-backups/live/*`. If uploading fails, the
completed archive is retained in `/var/backups/feather/failed/` with
root-only permissions; the staged individual objects are still removed.
Retained failed archives are not automatically pruned; remove them after
successfully retrying the upload.

Run one manually to test it:

```sh
sudo /usr/local/sbin/feather-s3-bucket-backup
```

### Manual pre-deployment archive

Before deploying, archive the deployed binaries and resources without stopping
the services:

```sh
sudo install -o root -g root -m 0750 \
    deployment/scripts/feather-deployment-backup \
    /usr/local/sbin/feather-deployment-backup
sudo /usr/local/sbin/feather-deployment-backup
```

This is intentionally not scheduled. It requires and archives the backend
(Server, Migrator, and Worker), WebApp, WebStatic, all five Feather systemd
unit files and enabled-unit links, `/etc/nginx/nginx.conf`, and the Feather
Nginx site config and enabled link. It also includes
`swift-runtime` if present. Each run gets a unique timestamped object under
`s3://feather-backups/live/YYYY/MM/DD/` so multiple pre-deployment
snapshots on the same day do not overwrite one another. The local temporary
archive is removed after a successful upload. A failed upload keeps the
completed archive in `/var/backups/feather/failed/` with root-only
permissions. Environment files containing secrets, TLS private keys and
certificates, and PostgreSQL data are excluded. The instance role needs
`s3:PutObject` on `arn:aws:s3:::feather-backups/live/*`.

CloudFront can use the private S3 bucket as its default origin with Origin
Access Control (OAC). Feather-generated public URLs match their S3 object keys:

```text
/public/{shard-prefix}/original.{extension}
/public/{shard-prefix}/variants/{variant-key}.{extension}
```

Server and Worker apply two shard levels of two characters by default, then
store objects under the bucket's top-level `public/` folder.
For ID `abcdefghijklmno`, physical S3 keys are
`public/ab/cd/efghijklmno/original.png` and
`public/ab/cd/efghijklmno/variants/cover.webp`. The `public/` component is
included in both the public URL and storage key. The CloudFront function is
optional for current generated URLs; it supports older readable paths such as
`/public/{shard-prefix}/originals/{path}/{filename}.{extension}` by mapping
them to the corresponding original object key. If you attach it to the media
behavior's viewer-request event, keep its shard constants aligned with the
Server and Worker environment.

CloudFront OAC needs `GET` and `HEAD` access to the `public/*` media keys;
Server and Worker need their current object read/write/delete and bucket
listing/multipart permissions. Media uploads still go to Server;
`MEDIA_PUBLIC_BASE_URL` controls the public CloudFront host. Do not clear the
bucket as part of a DB reset unless a full media reset is explicitly intended.

### Publish and attach the media URI rewrite function

The CloudFront Function source and test events are in `deployment/cloudfront/`.
Run these AWS CLI commands from the repository root with credentials that can
manage CloudFront Functions and the distribution. The function code must be
available at the path passed to `fileb://`.

Create it once:

```sh
aws cloudfront create-function \
    --name feather-beta-media-uri-to-s3-key \
    --function-config 'Comment=Map public media URLs to S3 object keys,Runtime=cloudfront-js-2.0' \
    --function-code fileb://deployment/cloudfront/media-uri-rewrite.js
```

Test both URL forms against the DEVELOPMENT stage, then publish the function
to LIVE. Use the current ETag returned by AWS; do not hardcode one:

```sh
function_etag="$(aws cloudfront describe-function \
    --name feather-beta-media-uri-to-s3-key \
    --query ETag --output text)"

for event in test-original-event.json test-variant-event.json; do
    aws cloudfront test-function \
        --name feather-beta-media-uri-to-s3-key \
        --if-match "$function_etag" \
        --event-object "fileb://deployment/cloudfront/$event"
done

aws cloudfront publish-function \
    --name feather-beta-media-uri-to-s3-key \
    --if-match "$function_etag"
```

Publishing does not attach the function to a distribution. Associate its LIVE
ARN with the default cache behavior's `viewer-request` event. This update
preserves the rest of the current distribution configuration and replaces any
existing viewer-request association on that behavior:

```sh
distribution_id=REPLACE_WITH_DISTRIBUTION_ID
function_arn="$(aws cloudfront describe-function \
    --name feather-beta-media-uri-to-s3-key --stage LIVE \
    --query FunctionSummary.FunctionMetadata.FunctionARN --output text)"
response="$(aws cloudfront get-distribution-config \
    --id "$distribution_id" --output json)"
distribution_etag="$(jq -r '.ETag' <<<"$response")"
distribution_config="$(jq -c --arg function_arn "$function_arn" '
    .DistributionConfig
    | .DefaultCacheBehavior.FunctionAssociations = (
        (.DefaultCacheBehavior.FunctionAssociations // {Quantity: 0, Items: []}) as $associations
        | ($associations.Items // [] | map(select(.EventType != "viewer-request"))) as $others
        | {
            Quantity: (($others | length) + 1),
            Items: ($others + [{EventType: "viewer-request", FunctionARN: $function_arn}])
        }
    )
' <<<"$response")"

aws cloudfront update-distribution \
    --id "$distribution_id" \
    --if-match "$distribution_etag" \
    --distribution-config "$distribution_config"
```

Wait for the distribution status to return to `Deployed` before considering
the change active. For future code changes, update the existing function with
`aws cloudfront update-function` using its current ETag, test it, then publish
the updated DEVELOPMENT stage with `aws cloudfront publish-function`. The
distribution association remains in place when the LIVE function is updated.

## Private API listener

`API_BASE_URL=http://127.0.0.1:8080` is the internal URL WebApp uses to call
Server on the same machine. `SERVER_HTTP_HOST=127.0.0.1` keeps the API listener
private; the website Nginx virtual host serves WebApp, while WebApp calls the
backend over loopback. Expose a separate API hostname only when the deployment
requires direct browser access to the API.

For a manual update, copy the generated distribution to the runtime path, run
Migrator when schema migrations are required, and restart the services:

```sh
sudo cp -a dist/. /opt/feather/
sudo chown -R feather:feather /opt/feather
sudo systemctl start feather-migrator.service
sudo systemctl restart feather-server.service feather-worker.service
sudo systemctl restart feather-web-app.service feather-web-static.service
```

## PostgreSQL

Create the application role and database. The password must match
`POSTGRES_PASSWORD` in `/etc/feather/feather.env`:

```sh
sudo -u postgres createuser --pwprompt feather
sudo -u postgres createdb --owner=feather feather
```

If `createuser` reports that `feather` already exists, skip that command
and set the existing role password instead:

```sh
sudo -u postgres psql
```

Then run the following inside the PostgreSQL prompt and exit with `\q`:

```text
\password feather
\q
```

Run `createdb` if the `feather` database does not already exist. An existing
role or database does not need to be recreated.

No tables need to be created manually. `feather-migrator.service` applies
the schema migrations when it is run manually:

```sh
sudo systemctl start feather-migrator.service
```

## systemd

Install the example units without the `.example` suffix:

```sh
for unit in deployment/systemd/*.service.example; do
    sudo install -m 0644 "$unit" \
        "/etc/systemd/system/$(basename "${unit%.example}")"
done
sudo systemctl daemon-reload
sudo systemctl enable --now feather-server.service feather-worker.service
sudo systemctl enable --now feather-web-app.service feather-web-static.service
```

Run the one-shot migrator manually when needed. It remains marked successful
after it finishes; use `systemctl restart feather-migrator.service` to run
the migrations again. Inspect output with `journalctl -u feather-migrator`
and the other service names above.

## TLS certificates with acme.sh

Ensure the website DNS record points to the server and that ports 80 and 443
are reachable. The commands below use acme.sh's Nginx mode, which temporarily
adds the ACME challenge configuration and restores the existing Nginx
configuration after validation. Run them as the account that owns your acme.sh
installation.

The official acme.sh documentation recommends installing certificates into
stable Nginx paths with `--install-cert`; do not reference files directly from
the internal `~/.acme.sh` directory. See the [acme.sh Nginx installation
documentation](https://github.com/acmesh-official/acme.sh#3-install-the-certificate-to-apachenginx).

Create the certificate directories. If acme.sh runs as a non-root user, make
that user the owner of these directories so renewal can replace the files:

```sh
sudo install -d -m 0755 \
    /etc/nginx/ssl/beta.feathercms.com
sudo chown "$(id -un):$(id -gn)" \
    /etc/nginx/ssl/beta.feathercms.com
```

Issue one certificate for each hostname:

```sh
acme.sh --issue --nginx -d beta.feathercms.com
```

Install the certificates at the paths used by the Nginx examples. The
`--reloadcmd` is stored by acme.sh and runs after future renewals:

```sh
acme.sh --install-cert -d beta.feathercms.com \
    --key-file /etc/nginx/ssl/beta.feathercms.com/private.key \
    --fullchain-file /etc/nginx/ssl/beta.feathercms.com/fullchain.cer \
    --reloadcmd "systemctl reload nginx"
```

If the acme.sh account cannot reload Nginx, grant it narrowly-scoped permission
for `systemctl reload nginx`, or run the acme.sh renewal job as root. Verify the
installed paths before enabling the Nginx sites:

```sh
sudo nginx -t
sudo systemctl reload nginx
```

## Nginx

Copy the website Nginx example into the enabled-sites directory and update its
certificate paths. Do not enable the separate API virtual host:

```sh
sudo cp deployment/nginx/beta.feathercms.com.conf.example \
    /etc/nginx/sites-available/beta.feathercms.com.conf
sudo ln -s /etc/nginx/sites-available/beta.feathercms.com.conf \
    /etc/nginx/sites-enabled/beta.feathercms.com.conf
sudo nginx -t
sudo systemctl reload nginx
```

The site hostname proxies HTML and application routes to `WebApp` on port 3456
and asset file extensions to `WebStatic` on port 4567. Public media is served
by CloudFront from S3, not through Nginx. The optional
`beta-api.feathercms.com.conf.example` is for deployments that intentionally
expose the API on its own hostname; it is not part of the default configuration.
