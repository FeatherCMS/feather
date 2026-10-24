public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

extension Public.Author.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let authorList: any Public.Author.List.Query.Interface
        public let authorDetail: any Public.Author.Detail.Query.Interface
        public let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            authorList: any Public.Author.List.Query.Interface,
            authorDetail: any Public.Author.Detail.Query.Interface,
            metadata: any WebModule.Metadata.Reference.Query.Interface
        ) {
            self.authorList = authorList
            self.authorDetail = authorDetail
            self.metadata = metadata
        }
    }
}
