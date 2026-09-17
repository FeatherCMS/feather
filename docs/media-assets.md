# Media assets

The media module stores a logical media library in PostgreSQL and the file
bytes in one configured `MediaStorage`. A media asset is a file node. Folders
are also nodes, so both types share stable IDs, names, local slugs, and a
cached `slug_path`.

## Database model

```
media_asset_node
  id             TEXT PRIMARY KEY
  parent_id      TEXT NULL -> media_asset_node.id
  name           TEXT NOT NULL
  slug           TEXT NOT NULL
  slug_path      TEXT UNIQUE NOT NULL
  created_at     TIMESTAMPTZ NOT NULL
  updated_at     TIMESTAMPTZ NOT NULL
  deleted_at     TIMESTAMPTZ NULL

media_asset_node_folder
  node_id          TEXT PRIMARY KEY -> media_asset_node.id
  asset_count      INTEGER NOT NULL
  total_size_bytes BIGINT NOT NULL

media_asset_node_file
  node_id           TEXT PRIMARY KEY -> media_asset_node.id
  storage_object_id TEXT UNIQUE NOT NULL -> media_asset_storage_object.id
  extension         TEXT NOT NULL
  content_type      TEXT NOT NULL
  size_bytes        BIGINT NOT NULL
  status            TEXT NOT NULL
  title             TEXT NULL
  alt_text          TEXT NULL

media_asset_storage_object
  id         TEXT PRIMARY KEY
  object_key TEXT UNIQUE NOT NULL
  created_at TIMESTAMPTZ NOT NULL
  deleted_at TIMESTAMPTZ NULL

media_processor
  id               TEXT PRIMARY KEY
  name             TEXT UNIQUE NOT NULL
  match_extensions TEXT NOT NULL
  command_template TEXT NOT NULL
  is_required      BOOLEAN NOT NULL
  is_active        BOOLEAN NOT NULL
  created_at       TIMESTAMPTZ NOT NULL
  updated_at       TIMESTAMPTZ NOT NULL

media_asset_variant
  id                TEXT PRIMARY KEY
  asset_id          TEXT NOT NULL -> media_asset_node_file.node_id
  processor_id      TEXT NOT NULL -> media_processor.id
  name              TEXT NOT NULL
  storage_object_id TEXT UNIQUE NOT NULL -> media_asset_storage_object.id
  extension         TEXT NOT NULL
  created_at        TIMESTAMPTZ NOT NULL
  UNIQUE(asset_id, processor_id)
  UNIQUE(asset_id, name)
```

`media_asset_node` owns `name`, `slug`, and `slug_path`. A folder or file
therefore has one consistent identity and URL-safe path. A folder's
`slug_path` is the slash-separated path from the root, for example
`products/summer`. A file in that folder might have `slug_path`
`products/summer/hero`.

`slug_path` is cached because it is used for lookup and public URLs. When a
folder is renamed or moved, its own path and every descendant path are updated
in one transaction. Local slugs are unique among siblings; root slugs are
unique among root nodes. The file extension is stored separately and is not
part of `slug_path`.

The folder aggregate fields contain the number of direct and descendant
assets and their total original byte size. Asset creation and removal update
the folder and each ancestor.

There is exactly one media storage. Storage objects are separate rows so the
database does not duplicate object keys in original-file and variant tables.
The referencing table provides the object's meaning; no storage scope or kind
column is required.

## Logical storage keys

Storage keys are immutable and do not include mutable folder names:

```
assets/{asset-id}/original.{extension}
assets/{asset-id}/variants/{processor-id}.{extension}
```

The database stores these logical keys in
`media_asset_storage_object.object_key`. They are not public URLs and must not
be returned to API consumers.

## Public URLs and resolution

API responses return delivery URLs with the stable asset ID and current
SEO-friendly slug path:

```
/media/assets/{asset-id}/{slug_path}.{extension}
/media/variants/{asset-id}/{variant-name}.{extension}
```

For example:

```
/media/assets/kitnA5mXY7cFexHPtSC9F/products/summer/hero.jpg
/media/variants/kitnA5mXY7cFexHPtSC9F/preview.webp
```

The server resolves the immutable ID first, then validates the requested slug
and extension. A stale slug path receives a permanent redirect to the current
canonical URL. This keeps links stable when a folder or file is renamed while
preserving descriptive URLs for search engines. The ID is the lookup key; the
slug path is the canonical presentation.

`resolve` is the consumer-facing batch endpoint for metadata and media
resolution. It returns original public URLs, SEO metadata, and generated
variant URLs. `list` is for list item objects and administration. The former
media lookup names are removed in the new API.

## Processors and variants

A processor matches normalized extensions and executes its command template
with temporary input/output paths, such as `{input.fullname}` and
`{output.fullname}`. The original object is never replaced. A successful run
writes a new storage object and creates one
`media_asset_variant(asset_id, processor_id)` row.

Variant names are stable processor names and are unique per asset. The
variant's output extension is stored independently because a processor may
change formats. Asset status is `uploaded` initially, then `processing` while
matching active processors are pending, and `ready` when all matching active
processors have generated variants or none match.

## Physical storage sharding

The database key and public URL remain unchanged when sharding is enabled.
Only the filesystem/object-store path changes. Configuration belongs to the
media module:

```
media.storage_shard_depth
media.storage_shard_segment_length
```

Defaults:

```
storage_shard_depth = 0       # disabled
storage_shard_segment_length = 2
```

Depth can be `1`, `2`, or `3` (or another explicitly configured value). The
segment length controls the number of asset-ID characters in each directory.
Shards are taken from the beginning of the immutable asset ID, not from a
digest:

```
asset ID:  kitnA5mXY7cFexHPtSC9F
depth:     3
length:    2
physical:  ki/tn/A5/mXY7cFexHPtSC9F/original.jpg
```

The corresponding variant ends with its processor object path:

```
ki/tn/A5/mXY7cFexHPtSC9F/variants/{processor-id}.webp
```

With depth `0`, the physical path is the logical key
`assets/{asset-id}/original.jpg` or
`assets/{asset-id}/variants/{processor-id}.webp`. Sharding is applied by the
storage client for upload, download, and deletion; public URL generation never
depends on it.

## Clean-install migration and seed data

The media table migration is intentionally a clean-install migration. It
creates the node, folder, file, storage-object, processor, and variant tables
and drops the removed media tables. Seed/import code creates storage-object
rows before file or variant rows, writes through the same storage abstraction,
and stores public asset URLs in imported content. Existing legacy media data is
not migrated by this design.

Future work: storage deduplication/content addressing and object garbage
collection are deliberately left as a TBD decision. The current one-to-one
object references keep deletion and ownership explicit.
