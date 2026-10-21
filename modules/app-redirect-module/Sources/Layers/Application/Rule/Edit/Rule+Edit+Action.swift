import FeatherModuleKit
import RedirectModule

extension RedirectModule.Rule.Edit {
    struct Action: PermissionAction {
        let key = RedirectModule.Rule.Permissions.update
    }
}
