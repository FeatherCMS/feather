public import BlogModule
public import FeatherModuleKit

extension AuthorLink.Edit {
    public struct Action: PermissionAction {
        public let key = BlogModule.Permissions.AuthorLinks.update
    }
}
