import SystemModule
import FeatherModuleKit

extension Variable.Add {
    struct Action: PermissionAction {
        let key = SystemModule.Variable.Permissions.create
    }
}
