import FeatherInfrastructure
import NewsApplication
import NewsInfrastructure
import WebInfrastructure

extension UseCases {

    public func makeListPublicArticles() -> ListPublicArticles {
        .init(
            query: DatabaseQueryExecutor(
                database: database,
                scope: { context in
                    ReadPublicNewsArticle(
                        article: ArticleDatabaseQueries(
                            context: context,
                            metadata: MetadataDatabaseQueries(
                                context: context
                            )
                        ),
                        category: CategoryDatabaseQueries(
                            context: context,
                            metadata: MetadataDatabaseQueries(
                                context: context
                            )
                        ),
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    )
                }
            )
        )
    }
}
