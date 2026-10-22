import FeatherOpenAPI

extension Tag.Parameters {
    struct UpdateMask: QueryParameterRepresentable {
        var openAPIIdentifier: String { "BlogTagParametersUpdateMask" }
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? {
            "Comma-separated list of fields to update. Include an optional field to clear it when omitted from the request body."
        }
        var schema: any OpenAPISchemaRepresentable {
            BlogTagUpdateMaskField().reference()
        }
    }
}

struct BlogTagIdParameter: PathParameterRepresentable {
    var name: String { "blogTagId" }
    var description: String? { "BlogTag id" }
    var schema: any OpenAPISchemaRepresentable {
        BlogTagIdField().reference()
    }
}
