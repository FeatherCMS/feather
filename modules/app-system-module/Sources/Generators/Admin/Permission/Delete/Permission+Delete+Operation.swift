import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Permission.Delete {
    struct Operation: Permission.Operation, DeleteOperation {
        var operationId: String? { "systemPermissionDelete" }
    }
}
