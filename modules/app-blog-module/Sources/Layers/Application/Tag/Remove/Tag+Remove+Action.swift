public import BlogModule
public import FeatherModuleKit

extension Tag.Remove {
    public struct Action: PermissionAction {
        public let key = BlogModule.Permissions.Tags.delete
    }
}
