import FeatherModuleKit
import RedirectModule

extension Rule.Edit {
    struct Action: PermissionAction {
        let key = Rule.Permissions.update
    }
}
