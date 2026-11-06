public import AuthDomain
public import AuthModule
public import FeatherModuleKit

extension Session.Extend {
    public struct Scope: FeatherModuleKit.Scope {
        public let session: any Session.Repository.Interface
        public init(session: any Session.Repository.Interface) {
            self.session = session
        }
    }
}
