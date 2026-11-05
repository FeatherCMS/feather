import FeatherOpenAPI

extension AuthorLink {
    enum Parameters {}
}

extension AuthorLink.Parameters {
    struct AuthorID: PathParameterRepresentable {
        var openAPIIdentifier: String { "BlogAuthorLinkAuthorIdParameter" }
        var name: String { "blogAuthorId" }
        var description: String? { "Blog author identifier" }
        var schema: any OpenAPISchemaRepresentable {
            Author.Schemas.ID().reference()
        }
    }

    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "BlogAuthorLinkIdParameter" }
        var name: String { "blogAuthorLinkId" }
        var description: String? { "Blog author link identifier" }
        var schema: any OpenAPISchemaRepresentable {
            AuthorLink.Schemas.ID().reference()
        }
    }
}
