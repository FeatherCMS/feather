public import FeatherModuleKit
public import UserModule

extension Identity.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let identity: any Identity.Search.Query.Interface

        public init(identity: any Identity.Search.Query.Interface) {
            self.identity = identity
        }
    }
}
