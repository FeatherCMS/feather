public import FeatherModuleKit
public import WebDomain
public import WebModule

extension Metadata.Remove {
    public struct Scope: FeatherModuleKit.Scope {
        public let metadata: any Metadata.Repository.Interface

        public init(metadata: any Metadata.Repository.Interface) {
            self.metadata = metadata
        }
    }
}
