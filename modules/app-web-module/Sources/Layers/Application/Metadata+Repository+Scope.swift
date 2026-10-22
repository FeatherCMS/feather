public import FeatherModuleKit
public import WebDomain
public import WebModule

extension Metadata.Repository {
    public struct Scope: FeatherModuleKit.Scope {
        public let metadata: any Interface

        public init(metadata: any Interface) {
            self.metadata = metadata
        }
    }
}
