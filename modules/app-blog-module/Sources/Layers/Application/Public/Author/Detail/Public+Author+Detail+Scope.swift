public import BlogModule
public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

extension Public.Author.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let author: any Public.Author.Detail.Query.Interface
        public let authorLink: any AuthorLink.List.Query.Interface
        public let postDetail: any Public.Post.Detail.Query.Interface
        public let postList: any Public.Post.List.Query.Interface
        public let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            author: any Public.Author.Detail.Query.Interface,
            authorLink: any AuthorLink.List.Query.Interface,
            postDetail: any Public.Post.Detail.Query.Interface,
            postList: any Public.Post.List.Query.Interface,
            metadata: any WebModule.Metadata.Reference.Query.Interface
        ) {
            self.author = author
            self.authorLink = authorLink
            self.postDetail = postDetail
            self.postList = postList
            self.metadata = metadata
        }
    }
}
