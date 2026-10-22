public import BlogModule
public import FeatherModuleKit

extension Settings.Detail {
    public struct Action: PermissionAction {
        public let key = Settings.Permissions.read
    }
}
