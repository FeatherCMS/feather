public import BlogModule
public import FeatherModuleKit

extension Author.List {
    public struct Action: PermissionAction {
        public let key = Author.Permissions.list
    }
}
