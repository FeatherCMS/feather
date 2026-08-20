import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import NewsApplication
import NewsInfrastructure
import SystemInfrastructure
import WebDomain
import WebInfrastructure

public struct UseCases: Sendable {
    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let authorizer: any Authorizer

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        authorizer: any Authorizer
    ) {
        self.database = database
        self.idGenerator = idGenerator
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
            database: database,
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
            database: database,
            idGenerator: idGenerator,
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
            database: database,
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
            database: database,
            idGenerator: idGenerator,
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
            database: database,
            idGenerator: idGenerator,
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

