public import FeatherModuleKit
public import NewsModule

extension Article.Add {
    public struct Action: PermissionAction {
        public let key = Article.Permissions.create
    }
}
