public import AuthDomain
public import AuthModule
public import FeatherModuleKit
public import UserDomain
public import UserModule

extension AuthModule.Auth.TokenAuth {
    public struct Scope: FeatherModuleKit.Scope {
        public let identity: any Identity.Repository.Interface
        public let authorization: any Identity.Authorization.Query.Interface
        public let session: any Session.Repository.Interface

        public init(
            identity: any Identity.Repository.Interface,
            authorization: any Identity.Authorization.Query.Interface,
            session: any Session.Repository.Interface
        ) {
            self.identity = identity
            self.authorization = authorization
            self.session = session
        }
    }
}
