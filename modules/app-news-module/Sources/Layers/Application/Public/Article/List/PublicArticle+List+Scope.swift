public import FeatherModuleKit
public import WebApplication
public import WebModule

extension PublicNewsArticle.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let article: any Query.Interface
        public let articleResolver:
            any PublicNewsArticle.Resolve.Query.Interface
        public let articleCategoryIDs:
            any PublicNewsArticle.CategoryIDs.Query.Interface
        public let relatedArticles:
            any PublicNewsArticle.Related.Query.Interface
        public let metadata: any WebModule.Metadata.Resolve.Query.Interface
        public let metadataDetails:
            any WebModule.Metadata.Resolve.Detail.Query.Interface

        public init(
            article: any Query.Interface,
            articleResolver: any PublicNewsArticle.Resolve.Query.Interface,
            articleCategoryIDs: any PublicNewsArticle.CategoryIDs.Query
                .Interface,
            relatedArticles: any PublicNewsArticle.Related.Query.Interface,
            metadata: any WebModule.Metadata.Resolve.Query.Interface,
            metadataDetails: any WebModule.Metadata.Resolve.Detail.Query
                .Interface
        ) {
            self.article = article
            self.articleResolver = articleResolver
            self.articleCategoryIDs = articleCategoryIDs
            self.relatedArticles = relatedArticles
            self.metadata = metadata
            self.metadataDetails = metadataDetails
        }
    }
}
