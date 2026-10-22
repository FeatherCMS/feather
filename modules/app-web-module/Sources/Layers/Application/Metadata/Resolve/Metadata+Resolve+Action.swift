public import FeatherModuleKit
public import WebModule

extension Metadata.Resolve {
    public struct Action: PermissionAction {
        public let key = WebModule.Permissions.Metadata.access
    }
}
