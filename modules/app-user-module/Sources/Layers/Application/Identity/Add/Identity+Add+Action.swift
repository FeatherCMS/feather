public import FeatherModuleKit
public import UserModule

extension Identity.Add {
    public struct Action: PermissionAction {
        public let key = Identity.Permissions.create
    }
}
