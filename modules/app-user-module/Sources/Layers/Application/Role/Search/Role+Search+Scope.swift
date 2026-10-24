public import FeatherModuleKit
public import UserModule

extension Role.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let role: any Role.Search.Query.Interface

        public init(role: any Role.Search.Query.Interface) {
            self.role = role
        }
    }
}
