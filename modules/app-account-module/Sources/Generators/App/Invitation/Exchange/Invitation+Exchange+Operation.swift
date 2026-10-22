import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Invitation.Exchange {
    struct Operation: OperationRepresentable {
        var operationId: String? { "accountInvitationExchange" }
        var tags: [any TagRepresentable] { [Account.Tag()] }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [200: Account.Auth.Response().reference()]
        }
    }
}
