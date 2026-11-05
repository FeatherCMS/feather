public import FeatherModuleKit
public import NewsModule

extension Category.Edit {
    public struct Action: PermissionAction {
        public let key = Category.Permissions.update
    }
}
