public import FeatherModuleKit
public import UserModule

extension Role.Add {
    public struct Action: PermissionAction {
        public let key = Role.Permissions.create
    }
}
