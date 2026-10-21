public import FeatherModuleKit
public import RedirectModule

extension RedirectModule.Rule.Resolve {
    public struct Scope: FeatherModuleKit.Scope {
        public let query: any Query.Interface

        public init(query: any Query.Interface) {
            self.query = query
        }
    }
}
