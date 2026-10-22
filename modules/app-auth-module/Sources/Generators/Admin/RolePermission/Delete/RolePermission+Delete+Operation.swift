import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthRolePermissionRemoveOperation: AuthRolePermissionOperation,
    DeleteOperation
{
    var operationId: String? { "authRolePermissionRemove" }
}
