public import AuthModule
public import FeatherModuleKit

extension AuthModule.Authorization.CurrentUser {
    public struct Scope: FeatherModuleKit.Scope {
        public let roles: any Authorization.Roles.Query.Interface
        public let permissions:
            any Authorization.Permissions.Query.Interface

        public init(
            roles: any Authorization.Roles.Query.Interface,
            permissions: any Authorization.Permissions.Query.Interface
        ) {
            self.roles = roles
            self.permissions = permissions
        }
    }
}
