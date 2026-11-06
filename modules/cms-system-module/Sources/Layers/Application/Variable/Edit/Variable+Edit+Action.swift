import FeatherModuleKit
import SystemModule

extension Variable.Edit {
    struct Action: PermissionAction {
        let key = SystemModule.Variable.Permissions.update
    }
}
