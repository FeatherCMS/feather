import FeatherModuleKit
import WebDomain
import WebModule

extension MenuItem.Detail {
    struct Action: PermissionAction {
        let key = MenuItem.Permissions.read
    }
}
