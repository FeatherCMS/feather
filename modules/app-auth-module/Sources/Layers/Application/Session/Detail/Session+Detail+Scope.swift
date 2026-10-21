public import AuthModule
public import FeatherModuleKit

extension Session.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let session: any Query.Interface
        public init(session: any Query.Interface) { self.session = session }
    }
}
