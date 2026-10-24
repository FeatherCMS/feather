import FeatherOpenAPI

struct MediaFolderParentIDParameter: QueryParameterRepresentable {
    var name: String { "parentId" }
    var required: Bool { false }
    var description: String? { "Filter folders by their parent folder." }
    var schema: any OpenAPISchemaRepresentable {
        MediaFolderNullableIdField().reference()
    }
}
