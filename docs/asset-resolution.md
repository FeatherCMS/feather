# Media URL resolution and delivery

This document is about media URLs: how the application constructs them, how
their public paths map to stored objects, and how CloudFront or a local Nginx
edge serves the bytes. Admin picker and upload UI behavior is documented
separately from this URL contract.

The shard-first URL scheme below is the application contract. A clean install
must configure the application and its edge function with the same shard
depth and segment length.

## URL inputs

The Media Resolver needs these values to produce a delivery URL:

| Value | Source | Purpose |
| --- | --- | --- |
| Public media base URL | Deployment configuration | Selects the CDN or local edge host. |
| Asset ID | Media database | Stable identity for the stored original and its variants. |
| Virtual `slug_path` and original filename | Media database | Human-readable URL path; not an S3 directory. |
| Original extension | Media database | Identifies the original object's format. |
| Variant key and generated extension | Variant records | Selects a generated output and its actual format. |
| Shard depth and segment length | Shared storage/edge configuration | Determines the ID prefix path. |

The slug path is virtual. Renaming or moving a media folder can change the
descriptive URL without changing the asset ID or object key. Slugs and
filenames should be URL-encoded by the resolver, not manually concatenated by
callers.

## Shard prefix

Sharding divides a fixed-length asset ID into path segments from left to
right. `depth` is the number of shard segments; `segmentLength` is the number
of ID characters in each shard segment. The remaining characters form the
last ID segment.

For ID `abcdefghijklmno`:

| Depth | Segment length | Shard prefix |
| ---: | ---: | --- |
| 2 | 2 | `ab/cd/efghijklmno` |
| 3 | 2 | `ab/cd/ef/ghijklmno` |
| 2 | 1 | `a/b/cdefghijklmno` |

The ID must be longer than `depth × segmentLength`; otherwise the application
uses the unsplit ID as the prefix, and the CloudFront rewrite accepts that
explicit fallback. The URL generator, storage adapter, CloudFront Function,
and Nginx rules must use the same settings. At depth zero, the ID itself
remains the first path component; only extra shard directories are disabled.

The deployment variables are `STORAGE_OBJECT_KEY_DEPTH` and
`STORAGE_OBJECT_KEY_SEGMENT_LENGTH`. The defaults are depth `2` and segment
length `2`, producing `ab/cd/efghijklmno`. Depth zero explicitly disables
additional shard directories.

## Target public URL and object-key contract

Put the route marker immediately after the shard prefix, before the virtual
slug. This fixed position distinguishes originals from variants and keeps
variant selection independent of filename punctuation.

```text
/public/{shard-prefix}/originals/{virtual-path}/{filename}.{extension}
/public/{shard-prefix}/variants/{variant-key}/{virtual-path}/{filename}.{extension}
```

The corresponding stored object keys are:

```text
public/{shard-prefix}/original.{original-extension}
public/{shard-prefix}/variants/{variant-key}.{generated-extension}
```

The object key has no leading slash. The leading slash in an HTTP request URI
is normal; it is not part of the S3 key.

### Original example

Assume a fifteen-character asset ID, a two-level shard configuration with two
characters per level, and this database virtual path:

```text
example/projects/product-launch/hero-image.png
```

The resolver returns:

```text
https://<media-domain>/public/ab/cd/efghijklmno/originals/example/projects/product-launch/hero-image.png
```

CloudFront or Nginx maps it to this object key:

```text
public/ab/cd/efghijklmno/original.png
```

### Variant examples

Suppose the stored variants are `cover.webp` and `preview.webp`. Their public
URLs include both the stable variant key and the descriptive virtual path:

```text
https://<media-domain>/public/ab/cd/efghijklmno/variants/cover/example/projects/product-launch/hero-image.webp
https://<media-domain>/public/ab/cd/efghijklmno/variants/preview/example/projects/product-launch/hero-image.webp
```

They resolve to:

```text
public/ab/cd/efghijklmno/variants/cover.webp
public/ab/cd/efghijklmno/variants/preview.webp
```

The URL extension for a variant comes from that generated variant record; it
does not have to match the original extension. The `variants/{variant-key}`
path segment makes the mapping unambiguous even if the original filename
contains hyphens or words such as `cover`.

## Resolution and canonical URLs

The application resolves asset metadata and generates public URLs using the
current media base URL. The browser requests those URLs directly from the media
host; image bytes should not be streamed through WebApp or Server.

The asset ID selects the stored object. The slug and filename make the public
URL readable but do not participate in object lookup. The resolver should
emit one current canonical URL for each asset and variant. A simple edge
rewrite has no database access, so an old slug can still resolve by ID but
cannot be redirected to the current slug by that rewrite alone. If strict
canonical redirects are required, implement them in an application resolver
or provide an explicit edge mapping.

Readable image URLs and filenames can provide context, but they are not a
substitute for descriptive alt text and relevant page content. See [Google's
image SEO guidance](https://developers.google.com/search/docs/appearance/google-images).

## Current and target storage keys

The target bucket layout uses keys such as:

```text
public/ab/cd/efghijklmno/original.png
public/ab/cd/efghijklmno/variants/cover.webp
```

PostgreSQL stores the logical object name and extension separately:

```text
original + {extension}
variants/{variant-key} + {extension}
```

Server and Worker construct physical keys as
`public/{shard-prefix}/{logical-key}.{extension}`. The `public/` prefix is a
fixed top-level bucket namespace and is not stored in PostgreSQL. For the
example ID above, the physical keys are:

```text
public/ab/cd/efghijklmno/original.png
public/ab/cd/efghijklmno/variants/cover.webp
```

PostgreSQL's object-key constraint validates the logical key shape. The
storage adapter and edge map use the physical key shape. A clean install must
start with media storage matching this layout; no legacy-key compatibility
mapping is provided.

## CloudFront and private S3

For AWS, use the private S3 bucket as a CloudFront origin with Origin Access
Control (OAC). Keep public bucket access disabled. CloudFront needs read access
to the media objects; Server and Worker need the storage permissions required
for their read/write/delete/list and multipart operations. Keep credentials in
runtime configuration, not in source or deployment logs. The deployment
runbook contains environment-specific bucket, region, credential, and AWS CLI
publishing instructions.

Attach a CloudFront Function to the `viewer-request` event for the behavior
that receives media requests. The target rewrite is:

```text
/public/{prefix}/originals/{slug...}/{filename}.{extension}
    -> /public/{prefix}/original.{extension}

/public/{prefix}/variants/{variant}/{slug...}/{filename}.{extension}
    -> /public/{prefix}/variants/{variant}.{extension}
```

`{prefix}` is the complete shard path, including the remaining ID segment.
The `public` path component is required and maps to the bucket's top-level
`public/` folder.
The function should validate the configured prefix shape, route marker,
variant key, and extension. It should pass non-media requests through
unchanged if associated with a behavior that also receives them. The function
changes the requested object URI; the browser keeps the descriptive URL, and
CloudFront fetches the resulting object from S3. The rewrite performs no
database lookup and does not proxy the image through the application server.

The CloudFront function source is `deploy/cloudfront/media-uri-rewrite.js` in
the Ava repository. Its `OBJECT_KEY_DEPTH` and `OBJECT_KEY_SEGMENT_LENGTH` constants
must match Server and Worker configuration. Test both original and variant
examples, malformed paths, missing objects, and non-media paths before
publishing or associating it. Publish the tested version to `LIVE`, associate
it with the intended behavior, then wait for the distribution to reach
`Deployed`.

Use cache headers and CloudFront TTLs consistent with URL mutability. Do not
mark slugged URLs `immutable` unless slug changes create a new canonical URL
and old URLs remain intentionally supported. Verify content type, `GET` and
`HEAD`, cache behavior, and access through the public distribution without
making the bucket public.

## Local Nginx edge

A local Nginx edge can serve the same public URL contract from a filesystem
whose root contains the target object keys. This example supports two shard
levels of two characters each and serves files from `/srv/media`:

```nginx
server {
    listen 8081;
    server_name media.local;

    root /srv/media;
    autoindex off;

    # /public/ab/cd/ef.../originals/<virtual path>/<filename>.png
    # -> /srv/media/public/ab/cd/ef.../original.png
    location ~ ^/public/(?<shard1>[A-Za-z0-9_-]{2})/(?<shard2>[A-Za-z0-9_-]{2})/(?<asset_tail>[A-Za-z0-9_-]+)/originals/(?:.*/)?[^/]+\.(?<ext>[A-Za-z0-9]+)$ {
        rewrite ^ /public/$shard1/$shard2/$asset_tail/original.$ext break;
        try_files $uri =404;
        add_header Cache-Control "public, max-age=3600" always;
    }

    # /public/ab/cd/ef.../variants/cover/<virtual path>/<filename>.webp
    # -> /srv/media/public/ab/cd/ef.../variants/cover.webp
    location ~ ^/public/(?<shard1>[A-Za-z0-9_-]{2})/(?<shard2>[A-Za-z0-9_-]{2})/(?<asset_tail>[A-Za-z0-9_-]+)/variants/(?<variant>[A-Za-z0-9_-]+)/(?:.*/)?[^/]+\.(?<ext>[A-Za-z0-9]+)$ {
        rewrite ^ /public/$shard1/$shard2/$asset_tail/variants/$variant.$ext break;
        try_files $uri =404;
        add_header Cache-Control "public, max-age=3600" always;
    }

    location / {
        return 404;
    }
}
```

Generate matching Nginx rules whenever shard depth or segment length changes.
The filesystem root must contain exactly the keys produced by the storage
adapter. For remote object storage, Nginx needs a properly authenticated
origin/proxy configuration; do not expose a private S3 bucket through an
unauthenticated proxy. Validate the configuration with `nginx -t` and test
originals, variants, missing objects, unknown variants, and traversal attempts.

## URL-related source map

Paths below are relative to the `feather` repository root.

| Source | URL responsibility |
| --- | --- |
| `feather-core/Sources/Contracts/MediaResolver.swift` | Applies the configured public media base URL to relative media paths. |
| `modules/app-media-module/Sources/Layers/Application/Adapters/MediaPublicURLs.swift` | Builds public original and variant URL paths. |
| `modules/app-media-module/Sources/Layers/Domain/Models/MediaAssetStorageObject.swift` | Builds unsharded logical original and variant object keys. |
| `feather-core/Sources/Layers/Domain/ObjectKeyGenerator.swift` | Defines the generator protocol and its error. |
| `feather-core/Sources/Layers/Infrastructure/HierarchicalObjectKeyGenerator.swift` | Builds hierarchical object-key prefixes. |
| `feather-core/Sources/Layers/Domain/StorageContext.swift` | Pairs a storage client with an object-key generator without depending on Infrastructure. |
| `deploy/cloudfront/media-uri-rewrite.js` in Ava | Rewrites the public URL contract to physical object keys. |

## Implementation status

The local application code, import path, database constraint, CloudFront
rewrite source, and test fixtures use this shard-first URL/key contract. The
CloudFront function and Nginx edge configuration are deployment artifacts:
they must be configured with the same shard settings as the running services.
This source change does not publish a CloudFront function or alter any remote
database, bucket, or server.

## URL verification checklist

- The resolver emits the configured media host and one canonical slug path.
- Shard depth and segment length agree between URL generation, storage,
  CloudFront, and Nginx.
- Original URLs resolve to `/{prefix}/original.{extension}`.
- Variant URLs resolve to `/{prefix}/variants/{variant-key}.{extension}`.
- Public variant extensions match generated output metadata.
- URL-encoded slugs and filenames do not alter route-marker parsing.
- Stale slugs, missing objects, malformed paths, and unknown variants have
  deliberate behavior.
- Browser media requests go directly to CloudFront or Nginx, not through
  WebApp or Server.
- The S3 bucket remains private, or local filesystem permissions protect the
  Nginx origin.
