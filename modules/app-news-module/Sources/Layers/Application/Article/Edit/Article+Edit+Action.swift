public import FeatherModuleKit
public import NewsModule

extension Article.Edit {
    public struct Action: PermissionAction {
        public let key = Article.Permissions.update
    }
}
