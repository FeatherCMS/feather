public import FeatherModuleKit
public import NewsModule

extension Category.Remove {
    public struct Action: PermissionAction {
        public let key = Category.Permissions.delete
    }
}
