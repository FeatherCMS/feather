import FeatherOpenAPI

struct AuthMagicLinkIdParameter: PathParameterRepresentable {
    var name: String { "authMagicLinkId" }
    var description: String? { nil }
    var schema: any OpenAPISchemaRepresentable {
        AuthMagicLinkIdField().reference()
    }
}

struct AuthMagicLinkUpdateMaskParameter: QueryParameterRepresentable {
    var name: String { "updateMask" }
    var required: Bool { true }
    var description: String? {
        "Comma-separated fields to update: credentialId, isPersistent"
    }
    var schema: any OpenAPISchemaRepresentable {
        AuthMagicLinkUpdateMaskField().reference()
    }
}
