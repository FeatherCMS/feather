import FeatherOpenAPI

struct UserCredentialIdParameter: PathParameterRepresentable {
    var name: String { "userCredentialId" }
    var description: String? { nil }
    var schema: any OpenAPISchemaRepresentable {
        UserCredentialIdField().reference()
    }
}
