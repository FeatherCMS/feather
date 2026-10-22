public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

extension Public.Author.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let author: any Public.Author.Detail.Query.Interface
        public let authorList: any Public.Author.List.Query.Interface
        public let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            author: any Public.Author.Detail.Query.Interface,
            authorList: any Public.Author.List.Query.Interface,
            metadata: any WebModule.Metadata.Reference.Query.Interface
        ) {
            self.author = author
            self.authorList = authorList
            self.metadata = metadata
        }
    }
}
