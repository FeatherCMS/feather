public import BlogModule
public import FeatherModuleKit

extension Author.Search {
    public struct Action: PermissionAction {
        public let key = BlogModule.Permissions.Authors.list
    }
}
