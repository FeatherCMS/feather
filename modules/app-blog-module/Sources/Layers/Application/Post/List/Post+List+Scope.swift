public import BlogModule
public import FeatherModuleKit

extension Post.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let post: any Post.Query.Interface

        public init(post: any Post.Query.Interface) {
            self.post = post
        }
    }
}
