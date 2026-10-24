public import BlogModule
public import FeatherModuleKit

extension Post.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let post: any Post.List.Query.Interface

        public init(post: any Post.List.Query.Interface) {
            self.post = post
        }
    }
}
