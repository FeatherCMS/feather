public import FeatherModuleKit
public import UserModule

extension Role.Remove {
    public struct Action: PermissionAction {
        public let key = Role.Permissions.delete
    }
}
