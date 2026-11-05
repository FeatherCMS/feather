public import FeatherModuleKit
public import UserModule

extension Role.Detail {
    public struct Action: PermissionAction {
        public let key = Role.Permissions.read
    }
}
