public import BlogModule
public import FeatherModuleKit
public import WebApplication
public import WebDomain

extension Post.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let post: any Post.Query.Interface
        public let metadata: any Metadata.Query.Interface

        public init(
            post: any Post.Query.Interface,
            metadata: any Metadata.Query.Interface
        ) {
            self.post = post
            self.metadata = metadata
        }
    }
}
