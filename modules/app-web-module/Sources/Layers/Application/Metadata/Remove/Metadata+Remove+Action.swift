public import FeatherModuleKit
public import WebModule

extension Metadata.Remove {
    public struct Action: PermissionAction {
        public let key = WebModule.Permissions.Metadata.access
    }
}
