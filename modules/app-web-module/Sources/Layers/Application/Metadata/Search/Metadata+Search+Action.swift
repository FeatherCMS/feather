public import FeatherModuleKit
import SystemModule
import WebDomain
import WebModule

extension Metadata.Search {
    struct Action: PermissionAction {
        let key = WebModule.Permissions.Metadata.access
    }
}
