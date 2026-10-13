import FeatherOpenAPI

struct BlogPostIdParameter: PathParameterRepresentable {
    var name: String { "blogPostId" }
    var description: String? { "BlogPost id" }
    var schema: any OpenAPISchemaRepresentable {
        BlogPostIdField().reference()
    }
}
