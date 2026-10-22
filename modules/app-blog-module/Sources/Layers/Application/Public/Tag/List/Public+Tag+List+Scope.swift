public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

extension Public.Tag.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let tag: any Public.Query.TagContent.Interface
        public let metadata: any WebModule.Metadata.Query.Interface

        public init(
            tag: any Public.Query.TagContent.Interface,
            metadata: any WebModule.Metadata.Query.Interface
        ) {
            self.tag = tag
            self.metadata = metadata
        }
    }
}
