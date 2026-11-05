import FeatherOpenAPI

extension Asset.Folder.Query {
    enum Schemas {}
}

extension Asset.Folder.Query.Schemas {
    struct Filters: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            ["parentId": Asset.Folder.Schemas.NullableID()]
        }
    }

    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaFolderQueryItemSchema" }
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
