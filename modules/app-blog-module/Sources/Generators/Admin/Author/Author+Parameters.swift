import FeatherOpenAPI

extension Author {
    enum Parameters {}
}

extension Author.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "BlogAuthorIdParameter" }
        var name: String { "blogAuthorId" }
        var description: String? { "Blog author identifier" }
        var schema: any OpenAPISchemaRepresentable {
            Author.Schemas.ID().reference()
        }
    }
}
