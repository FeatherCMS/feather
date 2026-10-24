import FeatherModuleKit
import WebDomain
import WebModule

extension Page.Add {
    struct Action: PermissionAction {
        let key = WebModule.Permissions.Pages.create
    }
}
