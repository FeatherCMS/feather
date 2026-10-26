public import FeatherModuleKit
public import UserDomain
public import UserModule

extension Identity.Remove {
    public struct Scope: FeatherModuleKit.Scope {
        public let identity: any Identity.Repository.Interface

        public init(identity: any Identity.Repository.Interface) {
            self.identity = identity
        }
    }
}
