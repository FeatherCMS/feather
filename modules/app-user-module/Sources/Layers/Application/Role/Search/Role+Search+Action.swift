public import FeatherModuleKit
public import UserModule

extension Role.Search {
    public struct Action: PermissionAction {
        public let key = Role.Permissions.list
    }
}
