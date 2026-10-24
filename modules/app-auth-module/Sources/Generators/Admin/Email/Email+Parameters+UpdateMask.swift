import FeatherOpenAPI

extension Email.Parameters {
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
