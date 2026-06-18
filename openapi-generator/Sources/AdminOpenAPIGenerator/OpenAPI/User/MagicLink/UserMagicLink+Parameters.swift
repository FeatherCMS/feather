import FeatherOpenAPI

struct UserMagicLinkIdParameter: PathParameterRepresentable {
    var name: String { "userMagicLinkId" }
    var description: String? { nil }
    var schema: any OpenAPISchemaRepresentable {
        UserMagicLinkIdField().reference()
    }
}
