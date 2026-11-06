import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Invitation.Resend {
    struct Operation: Invitation.IdentifiableOperation, BearerProtectedOperation
    {
        var operationId: String? { "accountInvitationResend" }
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
