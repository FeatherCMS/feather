public import FeatherModuleKit
public import NewsModule
public import WebApplication
public import WebModule

extension Public.Category.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let category: any Category.Detail.Query.Interface
        public let article: any Query.Interface
        public let articleCategoryIDs:
            any Public.Article.CategoryIDs.Query.Interface
        public let metadataDetails:
            any WebModule.Metadata.Resolve.Detail.Query.Interface

        public init(
            category: any Category.Detail.Query.Interface,
            article: any Query.Interface,
            articleCategoryIDs: any Public.Article.CategoryIDs.Query
                .Interface,
            metadataDetails: any WebModule.Metadata.Resolve.Detail.Query
                .Interface
        ) {
            self.category = category
            self.article = article
            self.articleCategoryIDs = articleCategoryIDs
            self.metadataDetails = metadataDetails
        }
    }
}
