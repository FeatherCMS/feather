public import BlogModule
public import FeatherModuleKit

extension Author.Add {
    public struct Action: PermissionAction {
        public let key = Author.Permissions.create
    }
}
