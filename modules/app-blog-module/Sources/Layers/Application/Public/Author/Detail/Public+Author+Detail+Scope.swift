public import BlogModule
public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

extension Public.Author.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let author: any Query.Interface
        public let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            author: any Query.Interface,
            metadata: any WebModule.Metadata.Reference.Query.Interface
        ) {
            self.author = author
            self.metadata = metadata
        }
    }
}
