public import BlogModule
public import FeatherModuleKit

extension Author.Remove {
    public struct Action: PermissionAction {
        public let key = Author.Permissions.delete
    }
}
