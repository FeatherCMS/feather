public import FeatherModuleKit
public import UserModule

extension Identity.Detail {
    public struct Action: PermissionAction {
        public let key = Identity.Permissions.read
    }
}
