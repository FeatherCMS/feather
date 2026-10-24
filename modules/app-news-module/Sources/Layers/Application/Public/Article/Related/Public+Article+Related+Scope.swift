public import FeatherModuleKit
public import WebApplication
public import WebModule

extension Public.Article.Related {
    public struct Scope: FeatherModuleKit.Scope {
        public let relatedArticles: any Query.Interface
        public let articleCategoryIDs:
            any Public.Article.CategoryIDs.Query.Interface
        public let metadataDetails:
            any WebModule.Metadata.Resolve.Detail.Query.Interface

        public init(
            relatedArticles: any Query.Interface,
            articleCategoryIDs: any Public.Article.CategoryIDs.Query
                .Interface,
            metadataDetails: any WebModule.Metadata.Resolve.Detail.Query
                .Interface
        ) {
            self.relatedArticles = relatedArticles
            self.articleCategoryIDs = articleCategoryIDs
            self.metadataDetails = metadataDetails
        }
    }
}
