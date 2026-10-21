public import FeatherModuleKit
import RedirectModule

extension RedirectModule.Rule.Detail {
    struct Action: PermissionAction {
        let key = RedirectModule.Rule.Permissions.read
    }
}
