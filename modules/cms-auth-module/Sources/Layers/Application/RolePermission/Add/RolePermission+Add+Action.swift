import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension RolePermission.Add {
    struct Action: PermissionAction {
        let key = RolePermission.Permissions.create
    }
}
