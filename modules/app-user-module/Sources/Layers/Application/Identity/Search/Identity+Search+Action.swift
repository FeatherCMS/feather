public import FeatherModuleKit
public import UserModule

extension Identity.Search {
    public struct Action: PermissionAction {
        public let key = Identity.Permissions.list
    }
}
