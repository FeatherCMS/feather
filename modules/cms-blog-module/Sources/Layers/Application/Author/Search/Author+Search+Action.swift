public import BlogModule
public import FeatherModuleKit

extension Author.Search {
    public struct Action: PermissionAction {
        public let key = Author.Permissions.list
    }
}
