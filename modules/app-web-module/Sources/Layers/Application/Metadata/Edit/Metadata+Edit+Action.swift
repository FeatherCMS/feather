public import FeatherModuleKit
public import WebModule

extension Metadata.Edit {
    public struct Action: PermissionAction {
        public let key = WebModule.Permissions.Metadata.access
    }
}
