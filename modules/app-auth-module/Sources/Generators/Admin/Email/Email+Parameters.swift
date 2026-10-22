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

    struct UpdateMask: QueryParameterRepresentable {
        var openAPIIdentifier: String { "AuthEmailParametersUpdateMask" }
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? {
            "Comma-separated fields to update: identityId, email"
        }
        var schema: any OpenAPISchemaRepresentable {
            Email.Schemas.UpdateMask().reference()
        }
    }
}
