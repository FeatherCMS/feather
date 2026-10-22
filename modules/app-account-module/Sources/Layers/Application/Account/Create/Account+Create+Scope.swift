public import AccountModule
public import AuthDomain
public import AuthModule
public import FeatherModuleKit
public import UserDomain
public import UserModule

extension Account.Create {
    public struct Scope: FeatherModuleKit.Scope {
        public let identity: any Identity.Repository.Interface
        public let authEmail: any Email.Repository.Interface
        public let credential: any Credential.Repository.Interface

        public init(
            identity: any Identity.Repository.Interface,
            authEmail: any Email.Repository.Interface,
            credential: any Credential.Repository.Interface
        ) {
            self.identity = identity
            self.authEmail = authEmail
            self.credential = credential
        }
    }
}
