public import BlogModule
public import FeatherModuleKit

extension Tag.Remove {
    public struct Action: PermissionAction {
        public let key = Tag.Permissions.delete
    }
}
