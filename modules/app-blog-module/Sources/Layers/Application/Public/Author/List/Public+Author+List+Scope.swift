public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

extension Public.Author.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let author: any Public.Query.AuthorContent.Interface
        public let metadata: any WebModule.Metadata.Query.Interface

        public init(
            author: any Public.Query.AuthorContent.Interface,
            metadata: any WebModule.Metadata.Query.Interface
        ) {
            self.author = author
            self.metadata = metadata
        }
    }
}
