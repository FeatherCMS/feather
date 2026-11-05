public import AuthDomain
public import AuthModule
public import FeatherModuleKit
public import UserDomain
public import UserModule

extension AuthModule.Authorization.SignIn.Credentials {
    public struct Scope: FeatherModuleKit.Scope {
        public let identity: any Identity.Repository.Interface
        public let roles: any Authorization.Roles.Query.Interface
        public let permissions: any Authorization.Permissions.Query.Interface
        public let credential: any Credential.Repository.Interface
        public let authEmail: any Email.Repository.Interface
        public let session: any Session.Repository.Interface

        public init(
            identity: any Identity.Repository.Interface,
            roles: any Authorization.Roles.Query.Interface,
            permissions: any Authorization.Permissions.Query.Interface,
            credential: any Credential.Repository.Interface,
            authEmail: any Email.Repository.Interface,
            session: any Session.Repository.Interface
        ) {
            self.identity = identity
            self.roles = roles
            self.permissions = permissions
            self.credential = credential
            self.authEmail = authEmail
            self.session = session
        }
    }
}
