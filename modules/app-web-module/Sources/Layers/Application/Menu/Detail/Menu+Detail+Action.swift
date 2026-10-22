import FeatherModuleKit
import WebDomain
import WebModule

extension Menu.Detail {
    struct Action: PermissionAction {
        let key = WebModule.Permissions.Menus.read
    }
}
