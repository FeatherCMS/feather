import FeatherModuleKit
import SystemModule

extension Variable.Remove {
    struct Action: PermissionAction {
        let key = SystemModule.Variable.Permissions.delete
    }
}
