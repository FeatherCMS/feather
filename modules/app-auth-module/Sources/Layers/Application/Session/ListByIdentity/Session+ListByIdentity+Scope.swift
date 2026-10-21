public import AuthModule
public import FeatherModuleKit

extension Session.ListByIdentity {
    public struct Scope: FeatherModuleKit.Scope {
        public let session: any Session.List.Query.Interface
        public init(session: any Session.List.Query.Interface) {
            self.session = session
        }
    }
}
