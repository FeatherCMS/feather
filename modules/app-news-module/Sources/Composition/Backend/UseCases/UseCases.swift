public import FeatherContracts
import FeatherDatabase
import FeatherDomain
public import FeatherInfrastructure
import NewsApplication
import NewsInfrastructure
import SystemInfrastructure
import WebInfrastructure

public struct UseCases: Sendable {
    let databaseContext: DatabaseClientContext
    let authorizer: any Authorizer

    public init(
        databaseContext: DatabaseClientContext,
        authorizer: any Authorizer
    ) {
        self.databaseContext = databaseContext
        self.authorizer = authorizer
    }

}

extension UseCases {

}

extension UseCases {
    func articleQuery() -> DatabaseQueryExecutor<
        ReadArticleMetadata
    > {
        DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                ReadArticleMetadata(
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
    }

    func articleTransaction() -> DatabaseTransactionExecutor<
        WriteArticleMetadata
    > {
        DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteArticleMetadata(
                    article: ArticleDatabaseRepository(context: context),
                    metadata: MetadataDatabaseRepository(context: context),
                    variable: VariableDatabaseQueries(
                        context: .init(connection: context.connection)
                    )
                )
            }
        )
    }

    func categoryQuery() -> DatabaseQueryExecutor<
        ReadCategoryMetadata
    > {
        DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                ReadCategoryMetadata(
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
    }

    func categoryTransaction() -> DatabaseTransactionExecutor<
        WriteCategoryMetadata
    > {
        DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteCategoryMetadata(
                    category: CategoryDatabaseRepository(context: context),
                    metadata: MetadataDatabaseRepository(context: context),
                    variable: VariableDatabaseQueries(
                        context: .init(connection: context.connection)
                    )
                )
            }
        )
    }

    func categoryArticlesTransaction()
        -> DatabaseTransactionExecutor<
            WriteCategoryArticlesMetadata
        >
    {
        DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteCategoryArticlesMetadata(
                    article: ArticleDatabaseRepository(context: context),
                    category: CategoryDatabaseRepository(context: context),
                    metadata: MetadataDatabaseRepository(context: context)
                )
            }
        )
    }
}
