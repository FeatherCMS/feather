import FeatherOpenAPI

struct MediaFolderIdParameter: PathParameterRepresentable {
    var name: String { "mediaFolderId" }
    var description: String? { "Media folder id" }
    var schema: any OpenAPISchemaRepresentable {
        MediaFolderIdField().reference()
    }
}

struct MediaFolderUpdateMaskParameter: QueryParameterRepresentable {
    var name: String { "updateMask" }
    var required: Bool { true }
    var description: String? { "Comma-separated fields to update." }
    var schema: any OpenAPISchemaRepresentable {
        MediaFolderUpdateMaskField().reference()
    }
}
