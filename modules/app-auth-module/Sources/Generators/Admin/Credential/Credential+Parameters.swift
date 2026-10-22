import FeatherOpenAPI

extension Credential.Parameters {

    struct AuthCredentialIdParameter: PathParameterRepresentable {
        var openAPIIdentifier: String { "AuthCredentialIdParameter" }
        var name: String { "authCredentialId" }
        var description: String? { nil }
        var schema: any OpenAPISchemaRepresentable {
            Credential.Schemas.AuthCredentialIdField().reference()
        }
    }
}

extension Credential.Parameters {

    struct AuthCredentialUpdateMaskParameter: QueryParameterRepresentable {
        var openAPIIdentifier: String { "AuthCredentialUpdateMaskParameter" }
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? {
            "Comma-separated fields to update: userId, email, password"
        }
        var schema: any OpenAPISchemaRepresentable {
            Credential.Schemas.AuthCredentialUpdateMaskField().reference()
        }
    }
}
