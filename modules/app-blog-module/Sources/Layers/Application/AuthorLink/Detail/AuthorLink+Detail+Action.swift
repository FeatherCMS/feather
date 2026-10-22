public import BlogModule
public import FeatherModuleKit

extension AuthorLink.Detail {
    public struct Action: PermissionAction {
        public let key = BlogModule.Permissions.AuthorLinks.read
    }
}
