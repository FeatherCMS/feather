public import BlogModule
public import FeatherModuleKit

extension Author.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let author: any Author.List.Query.Interface

        public init(author: any Author.List.Query.Interface) {
            self.author = author
        }
    }
}
