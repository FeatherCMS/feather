import FeatherInfrastructure
public import NewsApplication
import NewsInfrastructure
import WebInfrastructure

extension UseCases {

    public func makeGetPublicCategory() -> GetPublicCategory {
        .init(
            query: DatabaseQueryExecutor(
                database: database,
                scope: { context in
                    ReadPublicNewsCategory(
                        category: CategoryDatabaseQueries(
                            context: context,
                            metadata: MetadataDatabaseQueries(
                                context: context
                            )
                        ),
                        article: ArticleDatabaseQueries(
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
