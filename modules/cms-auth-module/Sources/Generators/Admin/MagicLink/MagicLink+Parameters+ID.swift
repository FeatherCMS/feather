import FeatherOpenAPI

extension MagicLink.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkIdParameter" }
        var name: String { "authMagicLinkId" }
        var description: String? { nil }
        var schema: any OpenAPISchemaRepresentable {
            MagicLink.Schemas.ID().reference()
        }
    }
}
