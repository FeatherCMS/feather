import FeatherModuleKit
import WebDomain
import WebModule

extension Page.Remove {
    struct Action: PermissionAction {
        let key = Page.Permissions.delete
    }
}
