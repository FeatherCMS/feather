public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

extension Public.Tag.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let tag: any Query.Interface
        public let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            tag: any Query.Interface,
            metadata: any WebModule.Metadata.Reference.Query.Interface
        ) {
            self.tag = tag
            self.metadata = metadata
        }
    }
}
