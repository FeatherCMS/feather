import FeatherModuleKit
import WebModule

extension Settings.Edit {
    struct Action: PermissionAction {
        let key = WebModule.Permissions.Settings.update
    }
}
