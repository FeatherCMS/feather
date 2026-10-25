public import BlogModule
public import FeatherModuleKit

extension Author.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let author: any Query.Interface

        public init(author: any Query.Interface) {
            self.author = author
        }
    }
}
