import FeatherModuleKit
import RedirectModule

extension RedirectModule.Rule.Add {
    struct Action: PermissionAction {
        let key = RedirectModule.Rule.Permissions.create
    }
}
