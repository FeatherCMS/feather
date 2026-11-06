public import BlogModule
public import FeatherModuleKit
import WebModule

extension BlogModule.Settings.Edit {
    public struct Action: PermissionAction {
        public let key = BlogModule.Settings.Permissions.update
    }
}
