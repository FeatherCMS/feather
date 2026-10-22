public import BlogModule
public import FeatherModuleKit

extension Post.Search {
    public struct Action: PermissionAction {
        public let key = BlogModule.Permissions.Posts.list
    }
}
