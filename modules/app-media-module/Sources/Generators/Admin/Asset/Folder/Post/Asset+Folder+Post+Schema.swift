import FeatherOpenAPI

extension Asset.Folder.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaFolderCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "parentId": Asset.Folder.Schemas.NullableID(),
                "name": Asset.Folder.Schemas.Name(),
            ]
        }
    }

    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String { "MediaFolderCreateRequestBody" }
        var schema: some SchemaRepresentable { Schema().reference() }
    }
}
