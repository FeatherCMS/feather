import FeatherOpenAPI

extension Asset.Folder.Query {
    enum Schemas {}
}

extension Asset.Folder.Query.Schemas {
    struct Filters: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            ["parentId": MediaFolderNullableIdField()]
        }
    }

    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaFolderQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": MediaFolderIdField().reference(),
                "parentId": MediaFolderNullableIdField(),
                "name": MediaFolderNameField(),
                "slug": MediaFolderSlugField(),
                "slugPath": MediaFolderSlugPathField(),
                "assetCount": MediaFolderCountField(),
                "totalSizeBytes": MediaFolderBytesField(),
                "createdAt": MediaFolderTimestampField(),
                "updatedAt": MediaFolderTimestampField(),
            ]
        }
    }
}
