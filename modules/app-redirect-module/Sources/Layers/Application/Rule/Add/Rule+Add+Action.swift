public import FeatherModuleKit
import RedirectModule

extension Rule.Add {
    struct Action: PermissionAction {
        let key = Rule.Permissions.create
    }
}
