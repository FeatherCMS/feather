public import BlogModule
public import FeatherModuleKit

extension Tag.Edit {
    public struct Action: PermissionAction {
        public let key = Tag.Permissions.update
    }
}
