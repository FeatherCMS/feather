import FeatherModuleKit
import WebDomain
import WebModule

extension Menu.List {
    struct Action: PermissionAction {
        let key = WebModule.Permissions.Menus.list
    }
}
