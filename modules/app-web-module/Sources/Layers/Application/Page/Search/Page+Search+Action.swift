import FeatherModuleKit
import WebDomain
import WebModule

extension Page.Search {
    struct Action: PermissionAction {
        let key = WebModule.Permissions.Pages.list
    }
}
