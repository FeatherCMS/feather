public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

extension Public.Post.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let post: any Public.Post.Detail.Query.Interface
        public let postList: any Public.Post.List.Query.Interface
        public let author: any Public.Author.Detail.Query.Interface
        public let tag: any Public.Tag.Detail.Query.Interface
        public let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            post: any Public.Post.Detail.Query.Interface,
            postList: any Public.Post.List.Query.Interface,
            author: any Public.Author.Detail.Query.Interface,
            tag: any Public.Tag.Detail.Query.Interface,
            metadata: any WebModule.Metadata.Reference.Query.Interface
        ) {
            self.post = post
            self.postList = postList
            self.author = author
            self.tag = tag
            self.metadata = metadata
        }
    }
}
