import AuthModule
import FeatherApplication
import FeatherModuleKit

extension RolePermission.Search {
    struct Action: PermissionAction {
        let key = RolePermission.Permissions.list
    }
}
