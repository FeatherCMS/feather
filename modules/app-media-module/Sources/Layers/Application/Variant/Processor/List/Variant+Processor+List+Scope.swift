public import FeatherModuleKit
public import MediaModule

extension Variant.Processor.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let query: any Query.Interface

        public init(query: any Query.Interface) {
            self.query = query
        }
    }
}
