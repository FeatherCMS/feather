public import BlogModule
public import FeatherModuleKit

extension Post.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let post: any Post.Search.Query.Interface

        public init(post: any Post.Search.Query.Interface) {
            self.post = post
        }
    }
}
