import FeatherApplication
import FeatherModuleKit
import WebDomain
import WebModule

extension Menu.Edit {
    struct Action: PermissionAction {
        let key = Menu.Permissions.update
    }
}
