import FeatherModuleKit
import WebDomain
import WebModule

extension MenuItem.Edit {
    struct Action: PermissionAction {
        let key = MenuItem.Permissions.update
    }
}
