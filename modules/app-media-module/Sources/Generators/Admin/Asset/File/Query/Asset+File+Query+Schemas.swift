import FeatherOpenAPI

extension Asset.File.Query {
    enum Schemas {}
}

extension Asset.File.Query.Schemas {
    struct Filters: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "search": Asset.File.Schemas.NullableText(required: false),
                "parentId": Asset.Folder.Schemas.NullableID(),
            ]
        }
    }

    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetNodeQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "kind": ItemKind(),
                "file": File().reference(required: false),
                "folder": Folder().reference(required: false),
            ]
        }
    }

    struct File: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetQueryItemFileSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Asset.File.Schemas.ID().reference(),
                "folderId": Asset.Folder.Schemas.NullableID(),
                "name": Asset.File.Schemas.FileName(),
                "slug": Asset.File.Schemas.Slug(),
                "slugPath": Asset.File.Schemas.SlugPath(),
                "url": Asset.File.Schemas.URL(),
                "extension": Asset.File.Schemas.FileExtension(),
                "contentType": Asset.File.Schemas.ContentType(),
                "sizeBytes": Asset.File.Schemas.SizeBytes(),
                "status": Asset.File.Schemas.Status(),
                "title": Asset.File.Schemas.NullableText(required: false),
                "altText": Asset.File.Schemas.NullableText(required: false),
                "createdAt": Asset.File.Schemas.Timestamp(),
                "updatedAt": Asset.File.Schemas.Timestamp(),
            ]
        }
    }

    struct Folder: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetQueryItemFolderSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Asset.Folder.Schemas.ID().reference(),
                "parentId": Asset.Folder.Schemas.NullableID(),
                "name": Asset.Folder.Schemas.Name(),
                "slug": Asset.Folder.Schemas.Slug(),
                "slugPath": Asset.Folder.Schemas.SlugPath(),
                "assetCount": Asset.Folder.Schemas.Count(),
                "totalSizeBytes": Asset.Folder.Schemas.Bytes(),
                "createdAt": Asset.Folder.Schemas.Timestamp(),
                "updatedAt": Asset.Folder.Schemas.Timestamp(),
            ]
        }
    }
}
