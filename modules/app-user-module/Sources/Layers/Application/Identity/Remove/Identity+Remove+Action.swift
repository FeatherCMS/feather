public import FeatherModuleKit
public import UserModule

extension Identity.Remove {
    public struct Action: PermissionAction {
        public let key = Identity.Permissions.delete
    }
}
