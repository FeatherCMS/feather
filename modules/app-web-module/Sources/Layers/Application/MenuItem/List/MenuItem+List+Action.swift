import FeatherModuleKit
import WebDomain
import WebModule

extension MenuItem.List {
    struct Action: PermissionAction {
        let key = WebModule.Permissions.MenuItems.list
    }
}
