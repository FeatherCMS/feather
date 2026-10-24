import FeatherModuleKit
import WebDomain
import WebModule

extension MenuItem.Search {
    struct Action: PermissionAction {
        let key = WebModule.Permissions.MenuItems.list
    }
}
