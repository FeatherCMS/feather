import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension RolePermission.Remove {
    struct Action: PermissionAction {
        let key = RolePermission.Permissions.delete
    }
}
