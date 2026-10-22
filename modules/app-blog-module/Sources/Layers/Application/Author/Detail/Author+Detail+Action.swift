public import BlogModule
public import FeatherModuleKit

extension Author.Detail {
    public struct Action: PermissionAction {
        public let key = BlogModule.Permissions.Authors.read
    }
}
