public import FeatherModuleKit
public import MediaDomain
public import MediaModule

extension Variant.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let query: any Query.Interface

        public init(
            query: any Query.Interface
        ) {
            self.query = query
        }
    }
}
