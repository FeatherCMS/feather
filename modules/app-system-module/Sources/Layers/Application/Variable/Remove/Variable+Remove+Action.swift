import SystemModule
import FeatherModuleKit

extension Variable.Remove {
    struct Action: PermissionAction {
        let key = SystemModule.Variable.Permissions.delete
    }
}
