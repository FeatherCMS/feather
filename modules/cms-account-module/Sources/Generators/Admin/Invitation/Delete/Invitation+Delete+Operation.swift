import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Invitation.Delete {
    struct Operation: Invitation.Operation, BearerProtectedOperation,
        DeleteOperation
    {
        var operationId: String? { "accountInvitationDelete" }
    }
}
