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
                "id": MediaFolderIdField().reference(),
                "parentId": MediaFolderNullableIdField(),
                "name": MediaFolderNameField().reference(),
                "slug": MediaFolderSlugField().reference(),
                "slugPath": MediaFolderSlugPathField().reference(),
                "assetCount": MediaFolderCountField().reference(),
                "totalSizeBytes": MediaFolderBytesField().reference(),
                "createdAt": MediaFolderTimestampField().reference(),
                "updatedAt": MediaFolderTimestampField().reference(),
            ]
        }
    }
}
