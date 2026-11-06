# Media URL resolution

This guide describes the current Media module URL and object-key construction. Deployment routing for a CDN or local file server is configured outside this repository.

## URL and storage key formats

The Media module generates these relative public URLs:

```text
/public/{shard-prefix}/original.{extension}
/public/{shard-prefix}/variants/{variant-key}.{extension}
```

The corresponding storage keys are:

```text
public/{shard-prefix}/original.{extension}
public/{shard-prefix}/variants/{variant-key}.{extension}
```

The URL path is based on the stable asset ID and object key. It does not contain the asset's folder path or filename.

`modules/cms-media-module/Sources/Layers/Application/Asset/File/Asset+File+PublicURLs.swift` builds the relative URLs. `StorageObject.Model.storageKey` builds stored keys. `feather-core/Sources/ModuleKit/MediaResolver.swift` adds the configured public media base URL to relative paths and leaves absolute URLs unchanged.

## Shard prefix

`HierarchicalObjectKeyGenerator` splits the asset ID from left to right. The `depth` setting is the number of leading shard segments; `segmentLength` is the number of characters in each segment. The remainder is the final segment.

With the default depth `2` and segment length `2`, `abcdefghijklmno` becomes:

```text
ab/cd/efghijklmno
```

If the ID is empty, generation fails. If the ID is not longer than `depth × segmentLength`, the generator returns it unchanged. A depth of zero also returns the ID unchanged.

The Server config reads `storage.object_key.depth` and `storage.object_key.segment_length`, which map to `STORAGE_OBJECT_KEY_DEPTH` and `STORAGE_OBJECT_KEY_SEGMENT_LENGTH`. Both default to `2`.

## Markdown image resolution

`MediaResolver.resolveMarkdownImages(in:)` prefixes relative Markdown image paths containing `/originals/` or `/variants/` with the configured media base URL. It preserves absolute URLs and unrelated Markdown paths. This supports existing content paths; newly generated Media URLs use the object-key formats shown above.

## Source map

| Responsibility | Source |
| --- | --- |
| Resolve relative media URLs | `feather-core/Sources/ModuleKit/MediaResolver.swift` |
| Generate original and variant public paths | `modules/cms-media-module/Sources/Layers/Application/Asset/File/Asset+File+PublicURLs.swift` |
| Build storage keys | `modules/cms-media-module/Sources/Layers/Domain/StorageObject/StorageObject+Model.swift` |
| Generate hierarchical prefixes | `feather-core/Sources/Layers/Infrastructure/HierarchicalObjectKeyGenerator.swift` |
| Configure shard depth and segment length | `application/Sources/Server/Config/ServerConfig+Loader.swift` |
