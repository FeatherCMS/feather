public import BlogModule
public import FeatherModuleKit

extension Author.List {
    public struct Action: PermissionAction {
        public let key = BlogModule.Permissions.Authors.list
    }
}
