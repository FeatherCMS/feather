import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role.Delete {
    struct Operation: Role.Operation, DeleteOperation {
        var operationId: String? { "userRoleRemove" }
    }
}
