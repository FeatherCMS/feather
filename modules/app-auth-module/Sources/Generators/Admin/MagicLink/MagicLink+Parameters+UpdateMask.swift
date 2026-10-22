import FeatherOpenAPI

extension MagicLink.Parameters {
    struct UpdateMask: QueryParameterRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkUpdateMaskParameter" }
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? {
            "Comma-separated fields to update: credentialId, isPersistent"
        }
        var schema: any OpenAPISchemaRepresentable {
            MagicLink.Schemas.UpdateMask().reference()
        }
    }
}
