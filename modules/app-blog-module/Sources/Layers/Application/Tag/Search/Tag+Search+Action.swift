public import BlogModule
public import FeatherModuleKit

extension Tag.Search {
    public struct Action: PermissionAction {
        public let key = Tag.Permissions.list
    }
}
