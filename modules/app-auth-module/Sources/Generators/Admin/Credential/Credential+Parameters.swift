import FeatherOpenAPI

struct AuthCredentialIdParameter: PathParameterRepresentable {
    var name: String { "authCredentialId" }
    var description: String? { nil }
    var schema: any OpenAPISchemaRepresentable {
        AuthCredentialIdField().reference()
    }
}

struct AuthCredentialUpdateMaskParameter: QueryParameterRepresentable {
    var name: String { "updateMask" }
    var required: Bool { true }
    var description: String? {
        "Comma-separated fields to update: userId, email, password"
    }
    var schema: any OpenAPISchemaRepresentable {
        AuthCredentialUpdateMaskField().reference()
    }
}
