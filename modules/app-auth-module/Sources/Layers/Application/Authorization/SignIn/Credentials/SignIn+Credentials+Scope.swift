public import AuthDomain
public import AuthModule
public import FeatherModuleKit
public import UserDomain
public import UserModule

extension AuthModule.Authorization.SignIn.Credentials {
    public struct Scope: FeatherModuleKit.Scope {
        public let identity: any Identity.Repository.Interface
        public let authorization: any AuthModule.Authorization.Query.Interface
        public let credential: any Credential.Repository.Interface
        public let authEmail: any Email.Repository.Interface
        public let session: any Session.Repository.Interface

        public init(
            identity: any Identity.Repository.Interface,
            authorization: any AuthModule.Authorization.Query.Interface,
            credential: any Credential.Repository.Interface,
            authEmail: any Email.Repository.Interface,
            session: any Session.Repository.Interface
        ) {
            self.identity = identity
            self.authorization = authorization
            self.credential = credential
            self.authEmail = authEmail
            self.session = session
        }
    }
}
