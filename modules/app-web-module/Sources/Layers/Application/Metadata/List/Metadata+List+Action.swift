import FeatherModuleKit
import SystemModule
import WebDomain
import WebModule

extension Metadata.List {
    struct Action: PermissionAction {
        let key = WebModule.Permissions.Metadata.access
    }
}
