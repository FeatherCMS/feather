import FeatherOpenAPI

extension Post {
    enum Parameters {}
}

extension Post.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "BlogPostIdParameter" }
        var name: String { "id" }
        var description: String? { "Blog post identifier" }
        var schema: any OpenAPISchemaRepresentable {
            BlogPostIdField().reference()
        }
    }
}
