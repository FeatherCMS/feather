public import FeatherModuleKit
public import WebModule

extension Metadata.Remove {
    public struct Action: PermissionAction {
        public let key = Metadata.Permissions.access
    }
}
