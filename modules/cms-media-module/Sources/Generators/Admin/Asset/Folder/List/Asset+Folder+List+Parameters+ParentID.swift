import FeatherOpenAPI

extension Asset.Folder.List.Parameters {
    struct ParentID: QueryParameterRepresentable {
        var openAPIIdentifier: String { "MediaFolderParentIDParameter" }
        var name: String { "parentId" }
        var required: Bool { false }
        var description: String? { "Filter folders by their parent folder." }
        var schema: any OpenAPISchemaRepresentable {
            Asset.Folder.Schemas.NullableID().reference()
        }
    }
}
