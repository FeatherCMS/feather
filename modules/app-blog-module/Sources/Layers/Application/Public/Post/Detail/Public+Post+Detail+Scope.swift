public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

extension Public.Post.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let post: any Query.Interface
        public let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            post: any Query.Interface,
            metadata: any WebModule.Metadata.Reference.Query.Interface
        ) {
            self.post = post
            self.metadata = metadata
        }
    }
}
