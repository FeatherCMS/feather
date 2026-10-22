public import AuthModule
public import FeatherModuleKit

extension AuthModule.Authorization {
    public struct Scope: FeatherModuleKit.Scope {
        public let permissions:
            any Authorization.Permissions.Query.Interface
        public let rolePermissions: any RolePermission.Lookup.Query.Interface

        public init(
            permissions: any Authorization.Permissions.Query.Interface,
            rolePermissions: any RolePermission.Lookup.Query.Interface
        ) {
            self.permissions = permissions
            self.rolePermissions = rolePermissions
        }
    }
}
