public import BlogModule
public import FeatherModuleKit

extension Post.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let post: any Query.Interface

        public init(post: any Query.Interface) {
            self.post = post
        }
    }
}
