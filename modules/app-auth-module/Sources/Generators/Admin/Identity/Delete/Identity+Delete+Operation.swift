import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Identity.Session.Delete {
    struct Operation: Identity.IdentifiableOperation, DeleteOperation {
        var operationId: String? { "userIdentitySessionRemove" }
    }
}
