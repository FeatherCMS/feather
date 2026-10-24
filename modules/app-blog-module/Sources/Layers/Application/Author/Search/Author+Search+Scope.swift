public import BlogModule
public import FeatherModuleKit

extension Author.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let author: any Author.Search.Query.Interface

        public init(author: any Author.Search.Query.Interface) {
            self.author = author
        }
    }
}
