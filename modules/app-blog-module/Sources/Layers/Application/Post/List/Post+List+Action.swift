public import BlogModule
public import FeatherModuleKit

extension Post.List {
    public struct Action: PermissionAction {
        public let key = BlogModule.Permissions.Posts.list
    }
}
