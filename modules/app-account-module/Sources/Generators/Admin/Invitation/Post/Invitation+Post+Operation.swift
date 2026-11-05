import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Invitation.Post {
    struct Operation: Invitation.Operation, BearerProtectedOperation {
        var operationId: String? { "accountInvitationCreate" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: Invitation.Get.Response().reference()]
        }
    }
}
