import FeatherOpenAPI

extension Asset.Folder.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "MediaFolderIdParameter" }
        var name: String { "mediaFolderId" }
        var description: String? { "Media folder id" }
        var schema: any OpenAPISchemaRepresentable {
            Asset.Folder.Schemas.ID().reference()
        }
    }
}
