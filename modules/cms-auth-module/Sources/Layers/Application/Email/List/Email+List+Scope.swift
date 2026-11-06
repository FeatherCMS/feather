public import AuthModule
public import FeatherModuleKit

extension Email.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let authEmail: any Query.Interface

        public init(authEmail: any Query.Interface) {
            self.authEmail = authEmail
        }
    }
}
