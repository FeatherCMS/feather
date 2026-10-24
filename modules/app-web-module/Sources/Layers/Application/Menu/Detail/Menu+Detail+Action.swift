import FeatherModuleKit
import WebDomain
import WebModule

extension Menu.Detail {
    struct Action: PermissionAction {
        let key = Menu.Permissions.read
    }
}
