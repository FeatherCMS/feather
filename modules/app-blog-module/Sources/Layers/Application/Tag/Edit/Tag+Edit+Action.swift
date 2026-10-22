public import BlogModule
public import FeatherModuleKit

extension Tag.Edit {
    public struct Action: PermissionAction {
        public let key = BlogModule.Permissions.Tags.update
    }
}
