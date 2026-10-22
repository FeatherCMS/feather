public import FeatherModuleKit
public import NewsModule
public import WebApplication
public import WebModule

extension PublicNewsCategory.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let category: any Category.Detail.Query.Interface
        public let article: any PublicNewsArticle.List.Query.Interface
        public let articleCategoryIDs:
            any PublicNewsArticle.CategoryIDs.Query.Interface
        public let metadata: any WebModule.Metadata.Resolve.Query.Interface
        public let metadataDetails:
            any WebModule.Metadata.Resolve.Detail.Query.Interface

        public init(
            category: any Category.Detail.Query.Interface,
            article: any PublicNewsArticle.List.Query.Interface,
            articleCategoryIDs: any PublicNewsArticle.CategoryIDs.Query
                .Interface,
            metadata: any WebModule.Metadata.Resolve.Query.Interface,
            metadataDetails: any WebModule.Metadata.Resolve.Detail.Query
                .Interface
        ) {
            self.category = category
            self.article = article
            self.articleCategoryIDs = articleCategoryIDs
            self.metadata = metadata
            self.metadataDetails = metadataDetails
        }
    }
}
