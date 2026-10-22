public import FeatherModuleKit
public import WebApplication
public import WebDomain

extension Public.Author.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let author: any Public.Query.AuthorContent.Interface
        public let metadata: any Metadata.Query.Interface

        public init(
            author: any Public.Query.AuthorContent.Interface,
            metadata: any Metadata.Query.Interface
        ) {
            self.author = author
            self.metadata = metadata
        }
    }
}
