public import BlogModule
public import FeatherModuleKit

extension Post.List {
    public struct Action: PermissionAction {
        public let key = Post.Permissions.list
    }
}
