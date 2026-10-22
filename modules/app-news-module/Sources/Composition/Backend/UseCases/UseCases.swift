import FeatherDatabase
import FeatherDomain
public import FeatherInfrastructure
public import FeatherModuleKit
import NewsApplication
import NewsInfrastructure
import SystemApplication
import SystemInfrastructure
import SystemModule
import WebInfrastructure
import WebDomain

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
    }

    func articleTransaction() -> DatabaseTransactionExecutor<
        WriteArticleMetadata
    > {
        DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteArticleMetadata(
                    article: ArticleDatabaseRepository(context: context),
                    metadata: Metadata.Repository.Database(context: context),
                    variable: SystemModule.Variable.Lookup.Database(
                        context: context
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
    }

    func categoryTransaction() -> DatabaseTransactionExecutor<
        WriteCategoryMetadata
    > {
        DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteCategoryMetadata(
                    category: CategoryDatabaseRepository(context: context),
                    metadata: Metadata.Repository.Database(context: context),
                    variable: SystemModule.Variable.Lookup.Database(
                        context: context
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
                    metadata: Metadata.Repository.Database(context: context)
                )
            }
        )
    }
}
