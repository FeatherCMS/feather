public import FeatherModuleKit
public import NewsModule

extension Article.List {
    public struct Action: PermissionAction {
        public let key = Article.Permissions.list
    }
}
