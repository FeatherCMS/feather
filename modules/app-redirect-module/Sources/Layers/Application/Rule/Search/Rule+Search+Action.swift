import FeatherModuleKit
import RedirectModule

extension RedirectModule.Rule.Search {
    struct Action: PermissionAction {
        let key = RedirectModule.Rule.Permissions.search
    }
}
