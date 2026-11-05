import FeatherModuleKit
import SystemModule

extension Permission.Search {
    struct Action: PermissionAction {
        let key = SystemModule.Permission.Permissions.list
    }
}
