import FeatherOpenAPI

struct AuthCredentialIdParameter: PathParameterRepresentable {
    var name: String { "authCredentialId" }
    var description: String? { nil }
    var schema: any OpenAPISchemaRepresentable {
        AuthCredentialIdField().reference()
    }
}
