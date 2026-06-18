# Media Module Plan (POC)

This plan keeps the media domain intentionally minimal for a first implementation.

## Goals

- `media_assets` stores only core file-level data.
- `media_variants` stores shared variant identity and type.
- `media_image_variants` stores image-only variant settings.
- `media_video_variants` stores video-only variant settings.
- `media_variant_assets` links base assets to variants.
- Image/video-specific semantics stay out of `media_assets`.

## Database Model

### 1) `media_assets`

Purpose: canonical uploaded file record.

Suggested columns:

- `id` (uuid, primary key)
- `storage_key` (text, unique)
- `type` (text)
- `size_bytes` (bigint)
- `status` (varchar)
- `title` (text, nullable)
- `alt_text` (text, nullable)
- `created_at` (timestamp)
- `updated_at` (timestamp)
- `deleted_at` (timestamp, nullable)

Notes:

- `storage_key` is the storage location key (path without extension).
- `type` stores the uploaded media type (`png`, `jpeg`, `mp4` in current POC scope).
- `type` is extension-like by design in this POC (`png`, `jpeg`, `mp4`).
- Effective object path is built as: `storage_key + '.' + type`.
- Keep `status` generic for POC: `uploaded`, `processing`, `ready`.
- `title` and `alt_text` are canonical user-facing metadata stored at asset level.

### 2) `media_variants`

Purpose: shared variant definition table for both image and video variants.

Suggested columns:

- `id` (uuid, primary key)
- `name` (varchar)
- `type` (enum: `image`, `video`)
- `created_at` (timestamp)
- `updated_at` (timestamp)

Constraints:

- `unique(name, type)`

### 3) `media_image_variants`

Purpose: image-only settings for a variant.

Suggested columns:

- `variant_id` (uuid, pk + fk -> `media_variants.id`)
- `width` (int)
- `height` (int)
- `format` (enum: `png`, `jpeg`)

Constraints:

- `primary key (variant_id)`

Notes:

- Join from `media_variants` where `type = 'image'`.
- Preview image variants are square and normalized to `256x256`.
- Typical names in `media_variants.name`: `image_preview`, `pdf_preview`, `video_preview`.

### 4) `media_video_variants`

Purpose: video-only settings for a variant.

Suggested columns:

- `variant_id` (uuid, pk + fk -> `media_variants.id`)
- `format` (enum: `mp4`)
- `ffmpeg_args` (text)

Constraints:

- `primary key (variant_id)`

Notes:

- Join from `media_variants` where `type = 'video'`.
- Preview video variants are square and normalized to `256x256`.
- Typical names in `media_variants.name`: `video_preview`.
- `ffmpeg_args` stores the variant-specific ffmpeg argument string used during generation.

### 5) `media_variant_assets`

Purpose: link table between `media_assets` and `media_variants`.

Suggested columns:

- `id` (uuid, primary key)
- `asset_id` (uuid, fk -> `media_assets.id`, indexed)
- `variant_id` (uuid, fk -> `media_variants.id`, indexed)
- `storage_key` (text, unique)
- `created_at` (timestamp)

Constraints:

- `unique(asset_id, variant_id)`
- `unique(storage_key)`

## POC Decisions

- Originals are stored as a normal `media_assets` file.
- Generated image variants are linked via `media_variant_assets` to `media_variants(type=image)` and configured via `media_image_variants`.
- Generated video variants are linked via `media_variant_assets` to `media_variants(type=video)` and configured via `media_video_variants`.
- No MIME, codec, duration, or content metadata in this first model.
- Storage provider details are out of scope for now.
- No ownership column on `media_assets` in this POC.
- `media_assets` is internal and not shown directly in UI.
- Asset readiness is derived: an asset is usable only when all required variants are generated and linked.
- `media_assets.status` is used as the fast readiness flag for API/UI checks.
- `title`/`alt_text` are editable and apply to the base asset across variants.

## Readiness Rule

- Required image variants are defined by expected `media_variants.name` values where `type = 'image'`.
- Required video variants are defined by expected `media_variants.name` values where `type = 'video'`.
- An asset is `ready_for_usage = true` only if every required variant for its media type has a link row.
- For image assets, readiness checks required `media_variants(type=image)` links.
- For video assets, readiness checks required `media_variants(type=video)` links.
- Until all required variant links exist, the asset is `ready_for_usage = false`.
- `media_assets.status` transition:
  - `uploaded` -> `processing` when variant generation starts
  - `processing` -> `ready` when all required variant links exist
- UI should display available variants as they are linked, but must gate final asset usage on full readiness.

## Example Query Patterns

- List all usable assets:
  - `where status = 'ready' and deleted_at is null`
- Fetch all variants for one asset:
  - join `media_variant_assets` on `asset_id`
  - join `media_variants` by `variant_id`
  - left join `media_image_variants` by `variant_id` when `media_variants.type = 'image'`
  - left join `media_video_variants` by `variant_id` when `media_variants.type = 'video'`
- Check if asset is ready for usage:
  - count linked variants for `asset_id` where variant is in required set for that asset type
  - compare count to required set size
  - if complete, persist `media_assets.status = 'ready'`
- Resolve full object key:
  - asset: `storage_key || '.' || type`
  - variant: use stored finalized link `media_variant_assets.storage_key`

## Migration Order

1. Create `media_assets`.
2. Create `media_variants`.
3. Create `media_image_variants`.
4. Create `media_video_variants`.
5. Create `media_variant_assets`.
6. Add indexes and unique constraints.

## Migration Constraints Plan

- `media_assets`
  - `primary key (id)`
  - `unique (storage_key)`
  - `index (status, deleted_at)`
  - `index (type)`
- `media_variants`
  - `primary key (id)`
  - `unique (name, type)`
  - `index (type)`
- `media_image_variants`
  - `primary key (variant_id)`
  - `foreign key (variant_id) references media_variants(id) on delete cascade`
- `media_video_variants`
  - `primary key (variant_id)`
  - `foreign key (variant_id) references media_variants(id) on delete cascade`
- `media_variant_assets`
  - `primary key (id)`
  - `foreign key (asset_id) references media_assets(id) on delete cascade`
  - `foreign key (variant_id) references media_variants(id) on delete restrict`
  - `unique (asset_id, variant_id)`
  - `unique (storage_key)`
  - `index (asset_id)`
- Soft delete policy
  - `DELETE /media/assets/{assetId}` sets `deleted_at`.
  - Cascading hard deletes are only for explicit cleanup jobs, not API soft-delete.

## Domain Plan

- Module boundaries:
  - `MediaDomain`: entities, enums, invariants
  - `MediaApplication`: use cases/orchestration
  - `MediaInfrastructure`: storage, processors, repositories
- Domain entities:
  - `MediaAsset` (`id`, `storageKey`, `type`, `sizeBytes`, `status`, `title`, `altText`, timestamps, `deletedAt`)
  - `MediaVariant` (`id`, `name`, `type`, timestamps)
  - `MediaImageVariant` (`variantId`, `width`, `height`, `format`)
  - `MediaVideoVariant` (`variantId`, `format`, `ffmpegArgs`)
- Domain links:
  - `MediaVariantAssetLink` (`assetId`, `variantId`, `storageKey`)
- Domain rule:
  - `MediaAsset` readiness is derived from required variant sets and mirrored to `media_assets.status`.

## Permissions Plan

- Follow the existing permission style (`<module>:<resource>:<action>`).
- Define `MediaPermissions` in `MediaApplication/Permissions/MediaPermissions.swift`:
  - `media:assets:create`
  - `media:assets:list`
  - `media:assets:delete`
  - `media:processors:create`
  - `media:processors:list`
  - `media:processors:update`
  - `media:processors:delete`
- Use-case permission mapping:
  - `CreateMediaAsset` -> `media:assets:create`
  - `ListMediaAssets` / `SearchMediaAssets` / `GetMediaAssetDetails` -> `media:assets:list`
  - `DeleteMediaAsset` -> `media:assets:delete`
  - `CreateMediaProcessor` -> `media:processors:create`
  - `ListMediaProcessors` / `SearchMediaProcessors` / `GetMediaProcessorDetails` -> `media:processors:list`
  - `UpdateMediaProcessor` -> `media:processors:update`
  - `DeleteMediaProcessor` -> `media:processors:delete`

## Application Plan

- Use cases:
  - `CreateMediaAsset` (persist base asset after upload)
  - `DeleteMediaAsset`
  - `ListMediaAssets`
  - `SearchMediaAssets`
  - `GetMediaAssetDetails`
  - `CreateImageVariantDefinition`
  - `GetImageVariantDefinition`
  - `ListImageVariantDefinitions`
  - `UpdateImageVariantDefinition`
  - `DeleteImageVariantDefinition`
  - `CreateVideoVariantDefinition`
  - `GetVideoVariantDefinition`
  - `ListVideoVariantDefinitions`
  - `UpdateVideoVariantDefinition`
  - `DeleteVideoVariantDefinition`
  - `GenerateImageVariants` (for `png/jpeg` assets)
  - `GenerateVideoVariants` (for `mp4` assets)
  - `LinkVariantToAsset`
  - `RefreshMediaAssetStatus`
- Processing flow:
  1. Upload creates `media_assets` row.
  2. `CreateMediaAsset` enqueues background work item with `assetId`.
  3. Background worker calls variant generation use case based on `media_assets.type`.
  4. Worker calls `LinkVariantToAsset` for each generated variant.
  5. Worker calls `RefreshMediaAssetStatus`; when required set is complete set status to `ready`.
- POC failure behavior:
  - failed variant generation leaves asset in `processing`.
  - retry worker job keeps same `media_assets.id`.
  - status transitions are only `uploaded -> processing -> ready`.

## DTO Plan (match existing module style)

- Use the same DTO split style as other modules:
  - `MediaAssetCreate`
  - `MediaAssetDetail`
  - `MediaAssetList` with nested `Item` and nested `Query`
  - `MediaVariantCreate` / `MediaVariantDetail` / `MediaVariantList`
  - `MediaImageVariantCreate` / `MediaImageVariantDetail` / `MediaImageVariantList`
  - `MediaVideoVariantCreate` / `MediaVideoVariantDetail` / `MediaVideoVariantList`
- Search DTO pattern:
  - request query includes `page: Search.Page` (same shared type as existing modules)
  - `Search.Page` follows existing fields (`number`, `size`)
  - list/search responses include `items` + `total`
- Field mapping rule:
  - DTO fields map directly to DB plan fields (`storage_key`, `type`, `size_bytes`, `status`, `title`, `alt_text`, etc.).

## API Plan

- Internal endpoints (module-level):
  - `POST /media/assets`
  - `POST /media/assets/search`
  - `GET /media/assets/{assetId}`
  - `DELETE /media/assets/{assetId}`
- Admin CRUD endpoints (variant definitions):
  - `POST /admin/media/variants/image`
  - `GET /admin/media/variants/image`
  - `GET /admin/media/variants/image/{imageVariantId}`
  - `PATCH /admin/media/variants/image/{imageVariantId}`
  - `DELETE /admin/media/variants/image/{imageVariantId}`
  - `POST /admin/media/variants/video`
  - `GET /admin/media/variants/video`
  - `GET /admin/media/variants/video/{videoVariantId}`
  - `PATCH /admin/media/variants/video/{videoVariantId}`
  - `DELETE /admin/media/variants/video/{videoVariantId}`
- Response contract direction:
  - `POST /media/assets/search` is the canonical listing endpoint and follows existing page/size/total pattern.
  - `GET /media/assets/{assetId}` returns base asset plus full joined variant data:
    - shared `media_variants`
    - image config from `media_image_variants` when applicable
    - video config from `media_video_variants` when applicable
    - link-level resolved storage keys from `media_variant_assets`
    - readiness summary
- UI rule:
  - UI never displays bare `media_assets`.
  - UI consumes `POST /media/assets/search` and details endpoint, enabling selection only when `status = 'ready'`.
- Admin rule:
  - only admin-authorized users can call `/admin/media/*` CRUD endpoints.

## Error and Status Plan

- Domain/application error families (mirroring other modules):
  - `MediaAssetNotFound`
  - `MediaVariantNotFound`
  - `MediaVariantAlreadyLinked`
  - `MediaAssetTypeNotSupported`
  - `MediaAssetNotReady`
  - `MediaAssetAlreadyDeleted`
  - `MediaVariantDefinitionConflict`
- Status transitions:
  - create/upload: `uploaded`
  - worker start: `processing`
  - all required variants linked: `ready`
- API adapters map domain errors to existing HTTP error style used in server adapters.

## Module Structure Plan (follow existing patterns 100%)

- `app-modules/app-media-module/Package.swift`
- `app-modules/app-media-module/Sources/MediaDomain`
  - `Models/MediaAsset.swift`
  - `Models/MediaVariant.swift`
  - `Models/MediaImageVariant.swift`
  - `Models/MediaVideoVariant.swift`
  - `Models/MediaVariantAssetLink.swift`
  - `Repositories/MediaAssetRepository.swift`
  - `Repositories/MediaVariantRepository.swift`
  - `Repositories/MediaImageVariantRepository.swift`
  - `Repositories/MediaVideoVariantRepository.swift`
- `app-modules/app-media-module/Sources/MediaApplication`
  - `DTOs/*`
  - `Queries/*`
  - `Scopes/ReadMedia.swift`
  - `Scopes/WriteMedia.swift`
  - `Permissions/MediaPermissions.swift`
  - `UseCases/Asset/*`
  - `UseCases/Variant/*`
  - `UseCases/ImageVariant/*`
  - `UseCases/VideoVariant/*`
  - `UseCases/Worker/*`
  - `Adapters/*+DTOs.swift`
- `app-modules/app-media-module/Sources/MediaInfrastructure`
  - `Repositories/Database*Repository.swift`
  - `Queries/Database*Queries.swift`
  - `Workers/*` (background worker entry points invoking application use-cases)
- Server integration:
  - `Sources/Server/Modules/Builders/MediaModule.swift`
  - `Sources/Server/APIs/Admin/Media/*` endpoints following existing Admin API file splitting.

## Next Implementation Step

- Add module package structure (`Sources/MediaDomain`, `Sources/MediaApplication`, `Sources/MediaInfrastructure`) once this schema plan is approved.
