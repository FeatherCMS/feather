public import FeatherModuleKit
public import UserModule

extension Role.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let role: any Query.Interface

        public init(role: any Query.Interface) {
            self.role = role
        }
    }
}
