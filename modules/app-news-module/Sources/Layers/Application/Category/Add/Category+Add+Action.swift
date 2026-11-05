public import FeatherModuleKit
public import NewsModule

extension Category.Add {
    public struct Action: PermissionAction {
        public let key = Category.Permissions.create
    }
}
