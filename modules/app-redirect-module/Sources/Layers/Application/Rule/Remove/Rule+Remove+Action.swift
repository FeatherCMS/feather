import FeatherModuleKit
import RedirectModule

extension RedirectModule.Rule.Remove {
    struct Action: PermissionAction {
        let key = RedirectModule.Rule.Permissions.delete
    }
}
