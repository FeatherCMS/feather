public import BlogModule
public import FeatherModuleKit

extension Settings.Get {
    public struct Action: PermissionAction {
        public let key = BlogModule.Permissions.Settings.read
    }
}
