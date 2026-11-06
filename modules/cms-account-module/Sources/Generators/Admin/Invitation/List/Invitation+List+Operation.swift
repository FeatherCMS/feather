import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Invitation.List {
    struct Operation: Invitation.Operation, BearerProtectedOperation {
        var operationId: String? { "accountInvitationList" }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
