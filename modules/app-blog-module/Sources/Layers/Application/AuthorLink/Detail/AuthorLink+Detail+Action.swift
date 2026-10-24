public import BlogModule
public import FeatherModuleKit

extension AuthorLink.Detail {
    public struct Action: PermissionAction {
        public let key = AuthorLink.Permissions.read
    }
}
