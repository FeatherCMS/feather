public import BlogDomain
public import BlogModule
public import FeatherModuleKit
public import WebDomain
public import WebModule

extension Post.Remove {
    public struct Scope: FeatherModuleKit.Scope {
        public let post: any Post.Repository.Interface
        public let metadata: any WebModule.Metadata.Repository.Interface

        public init(
            post: any Post.Repository.Interface,
            metadata: any WebModule.Metadata.Repository.Interface
        ) {
            self.post = post
            self.metadata = metadata
        }
    }
}
