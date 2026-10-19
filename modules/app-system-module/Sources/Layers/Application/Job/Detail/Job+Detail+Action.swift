import SystemModule
import FeatherModuleKit

extension Job.Detail {
    struct Action: PermissionAction {
        let key = SystemModule.Job.Permissions.read
    }
}
