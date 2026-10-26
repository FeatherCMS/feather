public import FeatherModuleKit
public import UserModule

extension Role.Edit {
    public struct Action: PermissionAction {
        public let key = Role.Permissions.update
    }
}
