import FeatherOpenAPI

extension Author.Parameters {
    struct UpdateMask: QueryParameterRepresentable {
        var openAPIIdentifier: String { "BlogAuthorParametersUpdateMask" }
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? {
            "Comma-separated list of fields to update. Include an optional field to clear it when omitted from the request body."
        }
        var schema: any OpenAPISchemaRepresentable {
            BlogAuthorUpdateMaskField().reference()
        }
    }
}

struct BlogAuthorIdParameter: PathParameterRepresentable {
    var name: String { "blogAuthorId" }
    var description: String? { "BlogAuthor id" }
    var schema: any OpenAPISchemaRepresentable {
        BlogAuthorIdField().reference()
    }
}
