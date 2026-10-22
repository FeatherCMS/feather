public import FeatherModuleKit
public import WebApplication
public import WebDomain

extension Public.Author.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let author: any Public.Query.AuthorContent.Interface
        public let authorLink: any Public.Query.AuthorLinkContent.Interface
        public let post: any Public.Query.PostContent.Interface
        public let metadata: any Metadata.Query.Interface

        public init(
            author: any Public.Query.AuthorContent.Interface,
            authorLink: any Public.Query.AuthorLinkContent.Interface,
            post: any Public.Query.PostContent.Interface,
            metadata: any Metadata.Query.Interface
        ) {
            self.author = author
            self.authorLink = authorLink
            self.post = post
            self.metadata = metadata
        }
    }
}
