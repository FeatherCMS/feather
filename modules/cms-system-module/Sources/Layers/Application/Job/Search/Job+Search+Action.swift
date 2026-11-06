import FeatherModuleKit
import SystemModule

extension Job.Search {
    struct Action: PermissionAction {
        let key = SystemModule.Job.Permissions.list
    }
}
