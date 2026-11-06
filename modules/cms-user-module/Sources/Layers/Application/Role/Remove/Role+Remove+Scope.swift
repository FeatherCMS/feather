public import FeatherModuleKit
public import UserDomain
public import UserModule

extension Role.Remove {
    public struct Scope: FeatherModuleKit.Scope {
        public let role: any Role.Repository.Interface

        public init(role: any Role.Repository.Interface) {
            self.role = role
        }
    }
}
