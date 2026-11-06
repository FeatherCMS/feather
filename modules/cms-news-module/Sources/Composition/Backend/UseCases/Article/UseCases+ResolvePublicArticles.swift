import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {
    public func makeResolvePublicArticles()
        -> NewsApplication.Public.Article.Resolve.UseCase
    {
        .init(
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    NewsApplication.Public.Article.Resolve.Scope(
                        article: NewsApplication.Public.Article.Resolve.Query
                            .Database(
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
