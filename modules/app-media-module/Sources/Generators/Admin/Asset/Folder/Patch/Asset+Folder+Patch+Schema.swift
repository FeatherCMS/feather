import FeatherOpenAPI

extension Asset.Folder.Patch {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaFolderPatchSchema" }
        var propertyMap: SchemaMap {
            [
                "name": Asset.Folder.Schemas.Name().reference(required: false)
            ]
        }
    }

    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String { "MediaFolderPatchRequestBody" }
        var schema: some SchemaRepresentable { Schema().reference() }
    }
}
