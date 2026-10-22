public import BlogModule
public import FeatherModuleKit

extension Settings.Edit {
    public struct Action: PermissionAction {
        public let key = BlogModule.Permissions.Settings.update
    }
}
