public import BlogModule
public import FeatherModuleKit

extension Tag.Add {
    public struct Action: PermissionAction {
        public let key = BlogModule.Permissions.Tags.create
    }
}
