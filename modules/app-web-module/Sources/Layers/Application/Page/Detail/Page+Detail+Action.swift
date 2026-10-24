import FeatherModuleKit
import WebDomain
import WebModule

extension Page.Detail {
    struct Action: PermissionAction {
        let key = Page.Permissions.read
    }
}
