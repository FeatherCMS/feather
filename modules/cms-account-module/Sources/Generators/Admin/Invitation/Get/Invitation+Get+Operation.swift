import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Invitation.Get {
    struct Operation: Invitation.IdentifiableOperation, BearerProtectedOperation
    {
        var operationId: String? { "accountInvitationGet" }
        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: DefaultHTTPErrorContentResponse(
                    description: "Account invitation not found"
                ),
            ]
        }
    }
}
