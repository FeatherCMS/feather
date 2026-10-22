import FeatherOpenAPI

extension MagicLink.Parameters {

    struct AuthMagicLinkIdParameter: PathParameterRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkIdParameter" }
        var name: String { "authMagicLinkId" }
        var description: String? { nil }
        var schema: any OpenAPISchemaRepresentable {
            MagicLink.Schemas.AuthMagicLinkIdField().reference()
        }
    }
}

extension MagicLink.Parameters {

    struct AuthMagicLinkUpdateMaskParameter: QueryParameterRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkUpdateMaskParameter" }
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? {
            "Comma-separated fields to update: credentialId, isPersistent"
        }
        var schema: any OpenAPISchemaRepresentable {
            MagicLink.Schemas.AuthMagicLinkUpdateMaskField().reference()
        }
    }
}
