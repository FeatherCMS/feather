public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

extension Public.Post.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let post: any Public.Query.PostContent.Interface
        public let author: any Public.Query.AuthorContent.Interface
        public let tag: any Public.Query.TagContent.Interface
        public let metadata: any WebModule.Metadata.Query.Interface

        public init(
            post: any Public.Query.PostContent.Interface,
            author: any Public.Query.AuthorContent.Interface,
            tag: any Public.Query.TagContent.Interface,
            metadata: any WebModule.Metadata.Query.Interface
        ) {
            self.post = post
            self.author = author
            self.tag = tag
            self.metadata = metadata
        }
    }
}
