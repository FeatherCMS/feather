public import BlogModule
public import FeatherModuleKit

extension Post.Search {
    public struct Action: PermissionAction {
        public let key = Post.Permissions.list
    }
}
