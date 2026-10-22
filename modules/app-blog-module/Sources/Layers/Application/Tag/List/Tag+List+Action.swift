public import BlogModule
public import FeatherModuleKit

extension Tag.List {
    public struct Action: PermissionAction {
        public let key = Tag.Permissions.list
    }
}
