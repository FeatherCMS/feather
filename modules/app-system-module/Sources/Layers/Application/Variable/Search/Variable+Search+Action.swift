import FeatherModuleKit
import SystemModule

extension Variable.Search {
    struct Action: PermissionAction {
        let key = SystemModule.Variable.Permissions.list
    }
}
