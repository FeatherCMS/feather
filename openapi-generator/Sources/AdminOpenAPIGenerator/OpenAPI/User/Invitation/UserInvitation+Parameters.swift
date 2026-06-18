import FeatherOpenAPI

struct UserInvitationIdParameter: PathParameterRepresentable {
    var name: String { "userInvitationId" }
    var description: String? { "UserInvitation id" }
    var schema: any OpenAPISchemaRepresentable {
        UserInvitationIdField().reference()
    }
}
