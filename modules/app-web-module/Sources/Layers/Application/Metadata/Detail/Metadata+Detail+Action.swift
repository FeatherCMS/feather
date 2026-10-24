public import FeatherModuleKit
public import WebModule

extension Metadata.Detail {
    public struct Action: PermissionAction {
        public let key = Metadata.Permissions.access
    }
}
