import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
import WebInfrastructure
import WebDomain

extension UseCases {

    public func makeGetPublicCategory() -> GetPublicCategory {
        .init(
            query: DatabaseQueryExecutor(
                databaseContext: databaseContext,
                scope: { context in
                    ReadPublicNewsCategory(
                        category: CategoryDatabaseQueries(
                            context: context,
                            metadata: Metadata.Query.Database(
                                context: context
                            )
                        ),
                        article: ArticleDatabaseQueries(
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
