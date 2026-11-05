import FeatherOpenAPI

extension Credential.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "AuthCredentialIdParameter" }
        var name: String { "authCredentialId" }
        var description: String? { nil }
        var schema: any OpenAPISchemaRepresentable {
            Credential.Schemas.ID().reference()
        }
    }
}
