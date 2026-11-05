public import BlogModule
public import FeatherModuleKit

extension Post.Add {
    public struct Action: PermissionAction {
        public let key = Post.Permissions.create
    }
}
