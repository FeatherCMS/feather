import FeatherOpenAPI

extension Email.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "AuthEmailParametersID" }
        var name: String { "authEmailId" }
        var description: String? { nil }
        var schema: any OpenAPISchemaRepresentable {
            Email.Schemas.IDField().reference()
        }
    }
}
