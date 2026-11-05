public import BlogModule
public import FeatherModuleKit

extension Tag.Detail {
    public struct Action: PermissionAction {
        public let key = Tag.Permissions.read
    }
}
