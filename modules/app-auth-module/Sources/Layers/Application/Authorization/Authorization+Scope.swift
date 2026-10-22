public import AuthModule
public import FeatherModuleKit

extension AuthModule.Authorization {
    public struct Scope: FeatherModuleKit.Scope {
        public let authorization: any AuthModule.Authorization.Query.Interface
        public let rolePermissions: any RolePermission.Lookup.Query.Interface

        public init(
            authorization: any AuthModule.Authorization.Query.Interface,
            rolePermissions: any RolePermission.Lookup.Query.Interface
        ) {
            self.authorization = authorization
            self.rolePermissions = rolePermissions
        }
    }
}
