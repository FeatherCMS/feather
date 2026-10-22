import FeatherModuleKit
import WebDomain
import WebModule

extension Page.Remove {
    struct Action: PermissionAction {
        let key = WebModule.Permissions.Pages.delete
    }
}
