import SystemModule
import FeatherModuleKit

extension Variable.Edit {
    struct Action: PermissionAction {
        let key = SystemModule.Variable.Permissions.update
    }
}
