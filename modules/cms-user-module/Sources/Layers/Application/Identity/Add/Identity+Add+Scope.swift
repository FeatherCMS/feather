public import FeatherModuleKit
public import UserDomain
public import UserModule

extension Identity.Add {
    public struct Scope: FeatherModuleKit.Scope {
        public let identity: any Identity.Repository.Interface
        public let role: any Role.Repository.Interface

        public init(
            identity: any Identity.Repository.Interface,
            role: any Role.Repository.Interface
        ) {
            self.identity = identity
            self.role = role
        }
    }
}
