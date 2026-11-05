import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Identity.Session.Delete {
    struct Operation: Identity.IdentifiableOperation, DeleteOperation {
        var operationId: String? { "userIdentitySessionRemove" }
    }
}
