public import AuthModule
public import FeatherModuleKit

extension Email.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let email: any Query.Interface

        public init(email: any Query.Interface) {
            self.email = email
        }
    }
}
