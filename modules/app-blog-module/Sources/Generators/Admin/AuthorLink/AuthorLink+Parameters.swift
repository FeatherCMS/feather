import FeatherOpenAPI

extension AuthorLink {
    enum Parameters {}
}

extension AuthorLink.Parameters {
    struct AuthorID: PathParameterRepresentable {
        var openAPIIdentifier: String { "BlogAuthorLinkAuthorIdParameter" }
        var name: String { "authorId" }
        var description: String? { "Blog author identifier" }
        var schema: any OpenAPISchemaRepresentable {
            BlogAuthorIdField().reference()
        }
    }

    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "BlogAuthorLinkIdParameter" }
        var name: String { "id" }
        var description: String? { "Blog author link identifier" }
        var schema: any OpenAPISchemaRepresentable {
            BlogAuthorLinkIdField().reference()
        }
    }
}
