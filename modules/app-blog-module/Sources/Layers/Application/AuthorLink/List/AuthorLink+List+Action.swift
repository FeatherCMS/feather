public import BlogModule
public import FeatherModuleKit

extension AuthorLink.List {
    public struct Action: PermissionAction {
        public let key = AuthorLink.Permissions.list
    }
}
