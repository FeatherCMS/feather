public import AccountModule
public import FeatherModuleKit

extension Invitation.Validate {
    public struct Scope: FeatherModuleKit.Scope {
        public let query: any Query.Interface

        public init(query: any Query.Interface) {
            self.query = query
        }
    }
}
