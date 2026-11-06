import FeatherModuleKit
import SystemModule

extension Job.Detail {
    struct Action: PermissionAction {
        let key = SystemModule.Job.Permissions.read
    }
}
