import FeatherModuleKit
import WebDomain
import WebModule

extension Menu.Remove {
    struct Action: PermissionAction {
        let key = WebModule.Permissions.Menus.delete
    }
}
