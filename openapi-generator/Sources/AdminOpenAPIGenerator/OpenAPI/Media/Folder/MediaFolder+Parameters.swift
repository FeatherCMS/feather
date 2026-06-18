import FeatherOpenAPI

struct MediaFolderIdParameter: PathParameterRepresentable {
    var name: String { "mediaFolderId" }
    var description: String? { "Media folder id" }
    var schema: any OpenAPISchemaRepresentable {
        MediaFolderIdField().reference()
    }
}
