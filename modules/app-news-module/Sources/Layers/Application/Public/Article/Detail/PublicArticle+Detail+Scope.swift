public import FeatherModuleKit
public import NewsModule

extension PublicNewsArticle.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let article: any Article.Detail.Query.Interface
        public let category: any Query.Interface

        public init(
            article: any Article.Detail.Query.Interface,
            category: any Query.Interface
        ) {
            self.article = article
            self.category = category
        }
    }
}
