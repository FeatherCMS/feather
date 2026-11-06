public import FeatherModuleKit
public import NewsModule

extension Category.List {
    public struct Action: PermissionAction {
        public let key = Category.Permissions.list
    }
}
