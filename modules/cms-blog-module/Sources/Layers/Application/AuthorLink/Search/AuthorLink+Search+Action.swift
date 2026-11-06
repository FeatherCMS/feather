public import BlogModule
public import FeatherModuleKit

extension AuthorLink.Search {
    public struct Action: PermissionAction {
        public let key = AuthorLink.Permissions.list
    }
}
