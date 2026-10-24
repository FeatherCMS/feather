public import BlogModule
public import FeatherModuleKit

extension Author.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let author: any Author.Detail.Query.Interface

        public init(author: any Author.Detail.Query.Interface) {
            self.author = author
        }
    }
}
