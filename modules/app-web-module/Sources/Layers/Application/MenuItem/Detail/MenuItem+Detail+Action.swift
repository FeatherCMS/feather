import FeatherModuleKit
import WebDomain
import WebModule

extension MenuItem.Detail {
    struct Action: PermissionAction {
        let key = WebModule.Permissions.MenuItems.read
    }
}
