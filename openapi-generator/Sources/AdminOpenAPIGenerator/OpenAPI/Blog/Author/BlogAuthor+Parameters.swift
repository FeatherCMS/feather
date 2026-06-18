import FeatherOpenAPI

struct BlogAuthorIdParameter: PathParameterRepresentable {
    var name: String { "blogAuthorId" }
    var description: String? { "BlogAuthor id" }
    var schema: any OpenAPISchemaRepresentable {
        BlogAuthorIdField().reference()
    }
}
