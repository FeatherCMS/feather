import FeatherOpenAPI

extension Post {
    enum Parameters {}
}

extension Post.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "BlogPostIdParameter" }
        var name: String { "blogPostId" }
        var description: String? { "Blog post identifier" }
        var schema: any OpenAPISchemaRepresentable {
            Post.Schemas.ID().reference()
        }
    }
}
