public import BlogModule
public import FeatherModuleKit

extension AuthorLink.Add {
    public struct Action: PermissionAction {
        public let key = BlogModule.Permissions.AuthorLinks.create
    }
}
