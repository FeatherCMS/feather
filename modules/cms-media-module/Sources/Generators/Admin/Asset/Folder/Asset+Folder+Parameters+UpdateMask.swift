import FeatherOpenAPI

extension Asset.Folder.Parameters {
    struct UpdateMask: QueryParameterRepresentable {
        var openAPIIdentifier: String { "MediaFolderUpdateMaskParameter" }
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? { "Comma-separated fields to update." }
        var schema: any OpenAPISchemaRepresentable {
            Asset.Folder.Schemas.UpdateMask().reference()
        }
    }
}
