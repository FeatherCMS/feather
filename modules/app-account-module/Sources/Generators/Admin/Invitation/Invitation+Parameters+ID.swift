import FeatherOpenAPI

extension Invitation.Parameters {
    struct ID: PathParameterRepresentable {
        var name: String { "accountInvitationId" }
        var description: String? { "Account invitation ID" }
        var schema: any OpenAPISchemaRepresentable {
            Invitation.Schemas.ID().reference()
        }
    }
}
