import FeatherModuleKit
import WebDomain
import WebModule

extension MenuItem.Move {
    struct Action: PermissionAction {
        let key = MenuItem.Permissions.update
    }
}
