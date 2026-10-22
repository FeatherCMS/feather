public import FeatherModuleKit
public import WebDomain

extension Metadata.Repository {
    public struct Scope: FeatherModuleKit.Scope {
        public let metadata: any Interface

        public init(metadata: any Interface) {
            self.metadata = metadata
        }
    }
}
