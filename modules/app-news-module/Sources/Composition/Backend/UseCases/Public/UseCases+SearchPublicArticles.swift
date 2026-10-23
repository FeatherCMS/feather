import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {
    public func makeSearchPublicArticles() -> Public.Article.Search.UseCase {
        .init(
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    Public.Article.Search.Scope(
                        article: ArticleDatabaseQueries(
                            context: context,
                            metadata: WebModule.Metadata.Query.Database(
                                context: context
                            )
                        ),
                        articleCategoryIDs: ArticleDatabaseQueries(
                            context: context,
                            metadata: WebModule.Metadata.Query.Database(
                                context: context
                            )
                        ),
                        metadataDetails: WebModule.Metadata.Query.Database(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
