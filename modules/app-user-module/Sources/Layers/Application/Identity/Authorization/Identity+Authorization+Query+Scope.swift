public import FeatherModuleKit
public import UserModule

extension Identity.Authorization.Query {
    public struct Scope: FeatherModuleKit.Scope {
        public let identity: any Interface

        public init(identity: any Interface) {
            self.identity = identity
        }
    }
}
