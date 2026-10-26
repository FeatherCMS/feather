import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension RolePermission.Delete {
    struct Operation: RolePermission.Operation, DeleteOperation {
        var operationId: String? { "authRolePermissionRemove" }
    }
}
