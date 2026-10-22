public import BlogModule
public import FeatherModuleKit

extension Author.Edit {
    public struct Action: PermissionAction {
        public let key = BlogModule.Permissions.Authors.update
    }
}
