import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension RolePermission.Delete {
    struct Operation: RolePermission.Operation, DeleteOperation {
        var operationId: String? { "authRolePermissionRemove" }
    }
}
