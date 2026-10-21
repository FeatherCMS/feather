public import FeatherModuleKit
public import UserModule

extension Identity.Edit {
    public struct Action: PermissionAction {
        public let key = Identity.Permissions.update
    }
}
