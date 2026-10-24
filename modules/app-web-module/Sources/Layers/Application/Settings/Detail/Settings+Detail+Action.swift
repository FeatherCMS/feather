public import FeatherModuleKit
public import WebModule

extension Settings.Detail {
    public struct Action: PermissionAction {
        public let key = WebModule.Permissions.Settings.read
    }
}
