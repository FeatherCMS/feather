public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

extension Public.Tag.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let tag: any Public.Query.TagContent.Interface
        public let post: any Public.Query.PostContent.Interface
        public let metadata: any WebModule.Metadata.Query.Interface

        public init(
            tag: any Public.Query.TagContent.Interface,
            post: any Public.Query.PostContent.Interface,
            metadata: any WebModule.Metadata.Query.Interface
        ) {
            self.tag = tag
            self.post = post
            self.metadata = metadata
        }
    }
}
