public import FeatherModuleKit
public import NewsModule

extension Article.Remove {
    public struct Action: PermissionAction {
        public let key = Article.Permissions.delete
    }
}
