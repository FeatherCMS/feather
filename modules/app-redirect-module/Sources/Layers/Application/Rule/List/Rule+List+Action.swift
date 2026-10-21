import FeatherModuleKit
import RedirectModule

extension RedirectModule.Rule.List {
    struct Action: PermissionAction {
        let key = RedirectModule.Rule.Permissions.list
    }
}
