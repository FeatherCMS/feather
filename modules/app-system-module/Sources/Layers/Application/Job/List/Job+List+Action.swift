import SystemModule
import FeatherModuleKit

extension Job.List {
    struct Action: PermissionAction {
        let key = SystemModule.Job.Permissions.list
    }
}
