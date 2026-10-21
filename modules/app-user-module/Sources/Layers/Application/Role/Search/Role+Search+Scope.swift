public import FeatherModuleKit
public import UserModule

extension Role.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let role: any Interface

        public init(role: any Interface) {
            self.role = role
        }
    }
}
