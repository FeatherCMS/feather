import FeatherOpenAPI

extension BlogPost.Parameters {
    struct UpdateMask: QueryParameterRepresentable {
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? {
            "Comma-separated list of fields to update. Include an optional field to clear it when omitted from the request body."
        }
        var schema: any OpenAPISchemaRepresentable {
            BlogPostUpdateMaskField().reference()
        }
    }
}

struct BlogPostIdParameter: PathParameterRepresentable {
    var name: String { "blogPostId" }
    var description: String? { "BlogPost id" }
    var schema: any OpenAPISchemaRepresentable {
        BlogPostIdField().reference()
    }
}
