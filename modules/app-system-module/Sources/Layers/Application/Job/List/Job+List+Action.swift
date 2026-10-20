import FeatherModuleKit
import SystemModule

extension Job.List {
    struct Action: PermissionAction {
        let key = SystemModule.Job.Permissions.list
    }
}
