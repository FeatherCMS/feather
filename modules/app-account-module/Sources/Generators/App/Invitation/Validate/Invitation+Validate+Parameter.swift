import FeatherOpenAPI

extension Invitation.Validate {
    struct TokenParameter: QueryParameterRepresentable {
        var name: String { "token" }
        var description: String? { "Invitation token" }
        var schema: any OpenAPISchemaRepresentable {
            Account.Auth.MagicLinkTokenField().reference()
        }
    }
}
