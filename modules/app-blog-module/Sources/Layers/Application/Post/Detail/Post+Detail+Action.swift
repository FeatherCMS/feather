public import BlogModule
public import FeatherModuleKit

extension Post.Detail {
    public struct Action: PermissionAction {
        public let key = BlogModule.Permissions.Posts.read
    }
}
