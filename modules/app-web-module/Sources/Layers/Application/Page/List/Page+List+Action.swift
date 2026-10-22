import FeatherModuleKit
import WebDomain
import WebModule

extension Page.List {
    struct Action: PermissionAction {
        let key = WebModule.Permissions.Pages.list
    }
}
