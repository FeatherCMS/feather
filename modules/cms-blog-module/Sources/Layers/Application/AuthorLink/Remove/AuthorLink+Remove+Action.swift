public import BlogModule
public import FeatherModuleKit

extension AuthorLink.Remove {
    public struct Action: PermissionAction {
        public let key = AuthorLink.Permissions.delete
    }
}
