public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

extension Public.Tag.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let tag: any Public.Tag.Detail.Query.Interface
        public let post: any Public.Post.List.Query.Interface
        public let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            tag: any Public.Tag.Detail.Query.Interface,
            post: any Public.Post.List.Query.Interface,
            metadata: any WebModule.Metadata.Reference.Query.Interface
        ) {
            self.tag = tag
            self.post = post
            self.metadata = metadata
        }
    }
}
