public import AuthDomain
public import AuthModule
public import FeatherModuleKit

extension AuthEmail.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let authEmail: any AuthEmail.Repository.Interface
        public init(authEmail: any AuthEmail.Repository.Interface) {
            self.authEmail = authEmail
        }
    }
}
