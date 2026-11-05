public import FeatherModuleKit
public import UserModule

extension Identity.List {
    public struct Action: PermissionAction {
        public let key = Identity.Permissions.list
    }
}
