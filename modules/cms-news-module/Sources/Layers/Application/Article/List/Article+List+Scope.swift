public import FeatherModuleKit
public import NewsModule

extension Article.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let article: any Query.Interface

        public init(article: any Query.Interface) {
            self.article = article
        }
    }
}
