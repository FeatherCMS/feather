public import AuthModule
public import FeatherModuleKit
public import UserModule

extension RolePermission.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let authorization: any Identity.Authorization.Query.Interface
        public let rolePermissions: any Query.Interface

        public init(
            authorization: any Identity.Authorization.Query.Interface,
            rolePermissions: any Query.Interface
        ) {
            self.authorization = authorization
            self.rolePermissions = rolePermissions
        }
    }
}
