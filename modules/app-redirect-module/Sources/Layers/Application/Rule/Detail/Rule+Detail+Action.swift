import FeatherModuleKit
import RedirectModule

extension Rule.Detail {
    struct Action: PermissionAction {
        let key = Rule.Permissions.read
    }
}
