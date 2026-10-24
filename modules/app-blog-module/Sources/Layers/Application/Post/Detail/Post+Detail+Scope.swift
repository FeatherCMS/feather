public import BlogModule
public import FeatherModuleKit

extension Post.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let post: any Post.Detail.Query.Interface

        public init(post: any Post.Detail.Query.Interface) {
            self.post = post
        }
    }
}
