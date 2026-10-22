public import FeatherModuleKit
public import WebApplication
public import WebDomain

extension Public.Tag.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let tag: any Public.Query.TagContent.Interface
        public let metadata: any Metadata.Query.Interface

        public init(
            tag: any Public.Query.TagContent.Interface,
            metadata: any Metadata.Query.Interface
        ) {
            self.tag = tag
            self.metadata = metadata
        }
    }
}
