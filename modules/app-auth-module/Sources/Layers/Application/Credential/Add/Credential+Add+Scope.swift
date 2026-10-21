public import AuthDomain
public import AuthModule
public import FeatherModuleKit

extension Credential.Add {
    public struct Scope: FeatherModuleKit.Scope {
        public let credential: any Credential.Repository.Interface
        public let authEmail: any AuthEmail.Repository.Interface

        public init(
            credential: any Credential.Repository.Interface,
            authEmail: any AuthEmail.Repository.Interface
        ) {
            self.credential = credential
            self.authEmail = authEmail
        }
    }
}
