public import BlogModule
public import FeatherModuleKit

extension Post.Remove {
    public struct Action: PermissionAction {
        public let key = BlogModule.Permissions.Posts.delete
    }
}
