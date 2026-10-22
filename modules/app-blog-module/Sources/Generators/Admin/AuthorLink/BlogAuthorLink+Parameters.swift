import FeatherOpenAPI

extension BlogAuthorLink.Parameters {
    struct UpdateMask: QueryParameterRepresentable {
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? {
            "Comma-separated list of fields to update. Include an optional field to clear it when omitted from the request body."
        }
        var schema: any OpenAPISchemaRepresentable {
            BlogAuthorLinkUpdateMaskField().reference()
        }
    }
}

struct BlogAuthorLinkAuthorIdParameter: PathParameterRepresentable {
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
