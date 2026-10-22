public import AuthModule
public import FeatherModuleKit

extension RolePermission.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let authorization: any AuthModule.Authorization.Query.Interface
        public let rolePermissions: any Query.Interface

        public init(
            authorization: any AuthModule.Authorization.Query.Interface,
            rolePermissions: any Query.Interface
        ) {
            self.authorization = authorization
            self.rolePermissions = rolePermissions
        }
    }
}
