public import FeatherModuleKit
public import WebModule

extension Metadata.Resolve {
    public struct Scope: FeatherModuleKit.Scope {
        public let metadata: any Query.Interface

        public init(metadata: any Query.Interface) {
            self.metadata = metadata
        }
    }
}
