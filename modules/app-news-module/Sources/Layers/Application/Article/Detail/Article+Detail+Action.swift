public import FeatherModuleKit
public import NewsModule

extension Article.Detail {
    public struct Action: PermissionAction {
        public let key = Article.Permissions.read
    }
}
