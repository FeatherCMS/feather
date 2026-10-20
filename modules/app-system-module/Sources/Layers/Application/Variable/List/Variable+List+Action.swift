import FeatherModuleKit
import SystemModule

extension Variable.List {
    struct Action: PermissionAction {
        let key = SystemModule.Variable.Permissions.list
    }
}
