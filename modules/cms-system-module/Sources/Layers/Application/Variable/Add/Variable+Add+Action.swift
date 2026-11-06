import FeatherModuleKit
import SystemModule

extension Variable.Add {
    struct Action: PermissionAction {
        let key = SystemModule.Variable.Permissions.create
    }
}
