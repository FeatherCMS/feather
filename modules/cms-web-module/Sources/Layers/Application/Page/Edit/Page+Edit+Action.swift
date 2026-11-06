import FeatherModuleKit
import WebDomain
import WebModule

extension Page.Edit {
    struct Action: PermissionAction {
        let key = Page.Permissions.update
    }
}
