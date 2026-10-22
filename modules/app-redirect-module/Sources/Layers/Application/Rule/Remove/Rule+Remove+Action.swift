public import FeatherModuleKit
import RedirectModule

extension Rule.Remove {
    struct Action: PermissionAction {
        let key = Rule.Permissions.delete
    }
}
