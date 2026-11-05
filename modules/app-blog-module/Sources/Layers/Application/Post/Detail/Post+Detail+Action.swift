public import BlogModule
public import FeatherModuleKit

extension Post.Detail {
    public struct Action: PermissionAction {
        public let key = Post.Permissions.read
    }
}
