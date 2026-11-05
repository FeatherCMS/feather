public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

extension Public.Post.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let postList: any Query.Interface
        public let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            postList: any Query.Interface,
            metadata: any WebModule.Metadata.Reference.Query.Interface
        ) {
            self.postList = postList
            self.metadata = metadata
        }
    }
}
