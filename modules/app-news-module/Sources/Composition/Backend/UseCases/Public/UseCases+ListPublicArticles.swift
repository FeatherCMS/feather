import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
import WebInfrastructure
import WebDomain

extension UseCases {

    public func makeListPublicArticles() -> ListPublicArticles {
        .init(
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    ReadPublicNewsArticle(
                        article: ArticleDatabaseQueries(
                            context: context,
                            metadata: Metadata.Query.Database(
                                context: context
                            )
                        ),
                        category: CategoryDatabaseQueries(
                            context: context,
                            metadata: Metadata.Query.Database(
                                context: context
                            )
                        ),
                        metadata: Metadata.Query.Database(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
