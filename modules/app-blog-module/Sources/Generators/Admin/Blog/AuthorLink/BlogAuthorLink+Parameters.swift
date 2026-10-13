import FeatherOpenAPI

struct BlogAuthorLinkMenuIdParameter: PathParameterRepresentable {
    var name: String { "blogAuthorId" }
    var description: String? { "BlogAuthor id" }
    var schema: any OpenAPISchemaRepresentable {
        BlogAuthorIdField().reference()
    }
}

struct BlogAuthorLinkIdParameter: PathParameterRepresentable {
    var name: String { "blogAuthorLinkId" }
    var description: String? { "BlogAuthorLink id" }
    var schema: any OpenAPISchemaRepresentable {
        BlogAuthorLinkIdField().reference()
    }
}
