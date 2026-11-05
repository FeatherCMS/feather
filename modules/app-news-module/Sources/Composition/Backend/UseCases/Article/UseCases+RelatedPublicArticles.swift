import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {
    public func makeRelatedPublicArticles()
        -> NewsApplication.Public.Article.Related.UseCase
    {
        .init(
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    NewsApplication.Public.Article.Related.Scope(
                        relatedArticles: NewsApplication.Public.Article.Related
                            .Query.Database(
                                context: context
                            ),
                        articleCategoryIDs: NewsApplication.Public.Article
                            .CategoryIDs.Query
                            .Database(context: context),
                        metadataDetails: WebModule.Metadata.Resolve.Detail.Query
                            .Database(
                                context: context
                            )
                    )
                }
            )
        )
    }
}
