public import AuthDomain
public import AuthModule
public import FeatherModuleKit

extension Email.Remove {
    public struct Scope: FeatherModuleKit.Scope {
        public let authEmail: any Email.Repository.Interface
        public init(authEmail: any Email.Repository.Interface) {
            self.authEmail = authEmail
        }
    }
}
