import FeatherModuleKit
import WebDomain
import WebModule

extension MenuItem.Add {
    struct Action: PermissionAction {
        let key = MenuItem.Permissions.create
    }
}
