public import FeatherModuleKit
public import WebApplication
public import WebModule

extension Public.Article.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let article: any Query.Interface
        public let articleCategoryIDs:
            any Public.Article.CategoryIDs.Query.Interface
        public let metadataDetails:
            any WebModule.Metadata.Resolve.Detail.Query.Interface

        public init(
            article: any Query.Interface,
            articleCategoryIDs: any Public.Article.CategoryIDs.Query
                .Interface,
            metadataDetails: any WebModule.Metadata.Resolve.Detail.Query
                .Interface
        ) {
            self.article = article
            self.articleCategoryIDs = articleCategoryIDs
            self.metadataDetails = metadataDetails
        }
    }
}
