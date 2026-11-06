public import FeatherModuleKit
public import UserModule

extension Role.List {
    public struct Action: PermissionAction {
        public let key = Role.Permissions.list
    }
}
