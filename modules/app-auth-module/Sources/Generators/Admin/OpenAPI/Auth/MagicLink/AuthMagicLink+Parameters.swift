import FeatherOpenAPI

struct AuthMagicLinkIdParameter: PathParameterRepresentable {
    var name: String { "authMagicLinkId" }
    var description: String? { nil }
    var schema: any OpenAPISchemaRepresentable {
        AuthMagicLinkIdField().reference()
    }
}
