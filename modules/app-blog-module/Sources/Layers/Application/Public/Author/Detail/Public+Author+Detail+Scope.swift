public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

extension Public.Author.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let author: any Public.Author.Detail.Query.Interface
        public let authorLink: any Public.AuthorLink.List.Query.Interface
        public let post: any Public.Post.List.Query.Interface
        public let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            author: any Public.Author.Detail.Query.Interface,
            authorLink: any Public.AuthorLink.List.Query.Interface,
            post: any Public.Post.List.Query.Interface,
            metadata: any WebModule.Metadata.Reference.Query.Interface
        ) {
            self.author = author
            self.authorLink = authorLink
            self.post = post
            self.metadata = metadata
        }
    }
}
