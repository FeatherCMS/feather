public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

extension Public.Author.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let authorList: any Query.Interface
        public let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            authorList: any Query.Interface,
            metadata: any WebModule.Metadata.Reference.Query.Interface
        ) {
            self.authorList = authorList
            self.metadata = metadata
        }
    }
}
