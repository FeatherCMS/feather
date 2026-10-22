import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
import WebDomain
import WebInfrastructure
import WebModule

extension UseCases {

    public func makeListPublicArticles() -> ListPublicArticles {
        .init(
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    PublicNewsArticle.List.Scope(
                        article: ArticleDatabaseQueries(
                            context: context,
                            metadata: WebModule.Metadata.Query.Database(
                                context: context
                            )
                        ),
                        articleResolver: ArticleDatabaseQueries(
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
                        relatedArticles: ArticleDatabaseQueries(
                            context: context,
                            metadata: WebModule.Metadata.Query.Database(
                                context: context
                            )
                        ),
                        metadata: WebModule.Metadata.Query.Database(
                            context: context
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
