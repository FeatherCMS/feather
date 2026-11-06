public import FeatherModuleKit
public import NewsModule

extension Category.Detail {
    public struct Action: PermissionAction {
        public let key = Category.Permissions.read
    }
}
