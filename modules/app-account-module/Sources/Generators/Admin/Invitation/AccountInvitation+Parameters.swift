import FeatherOpenAPI

struct AccountInvitationIdParameter: PathParameterRepresentable {
    var name: String { "accountInvitationId" }
    var description: String? { "AccountInvitation id" }
    var schema: any OpenAPISchemaRepresentable {
        AccountInvitationIdField().reference()
    }
}
