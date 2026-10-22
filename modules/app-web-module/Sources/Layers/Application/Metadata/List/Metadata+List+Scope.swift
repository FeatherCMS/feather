public import FeatherModuleKit
public import WebDomain

extension Metadata.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let metadata: any Query.Interface

        public init(metadata: any Query.Interface) {
            self.metadata = metadata
        }
    }
}
