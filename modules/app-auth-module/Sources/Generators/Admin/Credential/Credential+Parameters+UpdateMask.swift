import FeatherOpenAPI

extension Credential.Parameters {
    struct UpdateMask: QueryParameterRepresentable {
        var openAPIIdentifier: String { "AuthCredentialUpdateMaskParameter" }
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? {
            "Comma-separated fields to update: userId, email, password"
        }
        var schema: any OpenAPISchemaRepresentable {
            Credential.Schemas.UpdateMask().reference()
        }
    }
}
