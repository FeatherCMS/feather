import SystemModule
import FeatherModuleKit

extension Variable.Detail {
    struct Action: PermissionAction {
        let key = SystemModule.Variable.Permissions.read
    }
}
