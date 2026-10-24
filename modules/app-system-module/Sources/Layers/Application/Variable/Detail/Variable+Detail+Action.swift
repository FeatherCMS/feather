import FeatherModuleKit
import SystemModule

extension Variable.Detail {
    struct Action: PermissionAction {
        let key = SystemModule.Variable.Permissions.read
    }
}
