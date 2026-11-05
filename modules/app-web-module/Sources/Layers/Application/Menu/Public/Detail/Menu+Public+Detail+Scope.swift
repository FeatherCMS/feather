public import FeatherModuleKit
public import WebModule

extension Menu.Public.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let query: any Query.Interface

        public init(query: any Query.Interface) {
            self.query = query
        }
    }
}
