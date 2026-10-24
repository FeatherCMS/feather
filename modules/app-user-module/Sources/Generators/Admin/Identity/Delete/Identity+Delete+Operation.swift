import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Identity.Delete {
    struct Operation: Identity.Operation, DeleteOperation {
        var operationId: String? { "userIdentityDelete" }
    }
}
