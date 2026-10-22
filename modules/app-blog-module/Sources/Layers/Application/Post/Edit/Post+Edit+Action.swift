public import BlogModule
public import FeatherModuleKit

extension Post.Edit {
    public struct Action: PermissionAction {
        public let key = BlogModule.Permissions.Posts.update
    }
}
