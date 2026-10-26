import FeatherModuleKit
import WebDomain
import WebModule

extension MenuItem.Remove {
    struct Action: PermissionAction {
        let key = MenuItem.Permissions.delete
    }
}
