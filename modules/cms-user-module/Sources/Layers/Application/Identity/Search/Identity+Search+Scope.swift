public import FeatherModuleKit
public import UserModule

extension Identity.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let identity: any Query.Interface

        public init(identity: any Query.Interface) {
            self.identity = identity
        }
    }
}
