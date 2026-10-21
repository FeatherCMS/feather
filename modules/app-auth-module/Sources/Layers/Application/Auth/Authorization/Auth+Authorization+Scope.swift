public import AuthModule
public import FeatherModuleKit
public import UserModule

extension AuthModule.Auth.Authorization {
    public struct Scope: FeatherModuleKit.Scope {
        public let authorization: any Identity.Authorization.Query.Interface
        public let rolePermissions: any RolePermission.Lookup.Query.Interface

        public init(
            authorization: any Identity.Authorization.Query.Interface,
            rolePermissions: any RolePermission.Lookup.Query.Interface
        ) {
            self.authorization = authorization
            self.rolePermissions = rolePermissions
        }
    }
}
