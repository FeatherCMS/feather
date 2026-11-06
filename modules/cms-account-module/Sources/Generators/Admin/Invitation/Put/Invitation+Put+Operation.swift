import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Invitation.Put {
    struct Operation: Invitation.IdentifiableOperation, BearerProtectedOperation
    {
        var operationId: String? { "accountInvitationUpdate" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Invitation.Get.Response().reference(),
                404: DefaultHTTPErrorContentResponse(
                    description: "Account invitation not found"
                ),
            ]
        }
    }
}
