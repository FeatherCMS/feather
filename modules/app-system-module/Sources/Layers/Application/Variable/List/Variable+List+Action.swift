import SystemModule
import FeatherModuleKit

extension Variable.List {
    struct Action: PermissionAction {
        let key = SystemModule.Variable.Permissions.list
    }
}
