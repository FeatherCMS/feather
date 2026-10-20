import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Identity.Delete {
    struct Operation: Identity.Operation, DeleteOperation {
        var operationId: String? { "userIdentityDelete" }
    }
}
