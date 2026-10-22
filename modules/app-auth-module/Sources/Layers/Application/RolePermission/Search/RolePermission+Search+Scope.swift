public import AuthModule
public import FeatherModuleKit

extension RolePermission.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let rolePermissions: any Query.Interface

        public init(
            rolePermissions: any Query.Interface
        ) {
            self.rolePermissions = rolePermissions
        }
    }
}
