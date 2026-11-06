import FeatherOpenAPI

extension Asset.Folder.List {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "MediaFolderListSchema" }
        var items: (any SchemaRepresentable)? { ItemSchema().reference() }
    }

    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaFolderListItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Asset.Folder.Schemas.ID().reference(),
                "parentId": Asset.Folder.Schemas.NullableID(),
                "name": Asset.Folder.Schemas.Name().reference(),
                "slug": Asset.Folder.Schemas.Slug().reference(),
                "slugPath": Asset.Folder.Schemas.SlugPath().reference(),
                "assetCount": Asset.Folder.Schemas.Count().reference(),
                "totalSizeBytes": Asset.Folder.Schemas.Bytes().reference(),
                "createdAt": Asset.Folder.Schemas.Timestamp().reference(),
                "updatedAt": Asset.Folder.Schemas.Timestamp().reference(),
            ]
        }
    }
}
