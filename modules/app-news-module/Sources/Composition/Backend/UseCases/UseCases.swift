import FeatherDatabase
import FeatherDomain
public import FeatherInfrastructure
public import FeatherModuleKit
import NewsApplication
import NewsInfrastructure
import NewsModule
import SystemApplication
import SystemInfrastructure
import SystemModule
import WebDomain
import WebInfrastructure
import WebModule

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
    func articleDetailQuery() -> DatabaseQueryExecutor<Article.Detail.Scope> {
        DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Article.Detail.Scope(
                    article: Article.Detail.Query.Database(
                        context: context,
                        metadata: WebModule.Metadata.Reference.Query.Database(
                            context: context
                        )
                    )
                )
            }
        )
    }

    func articleListQuery() -> DatabaseQueryExecutor<Article.List.Scope> {
        DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Article.List.Scope(
                    article: Article.List.Query.Database(context: context)
                )
            }
        )
    }

    func articleSearchQuery() -> DatabaseQueryExecutor<Article.Search.Scope> {
        DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Article.Search.Scope(
                    article: Article.Search.Query.Database(context: context)
                )
            }
        )
    }

    func articleAddTransaction() -> DatabaseTransactionExecutor<
        Article.Add.Scope
    > {
        DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Article.Add.Scope(
                    article: Article.Repository.Database(context: context),
                    metadata: WebModule.Metadata.Repository.Database(
                        context: context
                    ),
                    variable: SystemModule.Variable.Lookup.Database(
                        context: context
                    )
                )
            }
        )
    }

    func articleEditTransaction() -> DatabaseTransactionExecutor<
        Article.Edit.Scope
    > {
        DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Article.Edit.Scope(
                    article: Article.Repository.Database(context: context),
                    metadata: WebModule.Metadata.Repository.Database(
                        context: context
                    )
                )
            }
        )
    }

    func articleRemoveTransaction() -> DatabaseTransactionExecutor<
        Article.Remove.Scope
    > {
        DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Article.Remove.Scope(
                    article: Article.Repository.Database(context: context),
                    metadata: WebModule.Metadata.Repository.Database(
                        context: context
                    )
                )
            }
        )
    }

    func categoryDetailQuery() -> DatabaseQueryExecutor<Category.Detail.Scope> {
        DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Category.Detail.Scope(
                    category: Category.Detail.Query.Database(
                        context: context,
                        metadata: WebModule.Metadata.Reference.Query.Database(
                            context: context
                        )
                    )
                )
            }
        )
    }

    func categoryListQuery() -> DatabaseQueryExecutor<Category.List.Scope> {
        DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Category.List.Scope(
                    category: Category.List.Query.Database(
                        context: context
                    )
                )
            }
        )
    }

    func categorySearchQuery() -> DatabaseQueryExecutor<Category.Search.Scope> {
        DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Category.Search.Scope(
                    category: Category.Search.Query.Database(
                        context: context
                    )
                )
            }
        )
    }

    func categoryAddTransaction() -> DatabaseTransactionExecutor<
        Category.Add.Scope
    > {
        DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Category.Add.Scope(
                    category: Category.Repository.Database(context: context),
                    metadata: WebModule.Metadata.Repository.Database(
                        context: context
                    ),
                    variable: SystemModule.Variable.Lookup.Database(
                        context: context
                    )
                )
            }
        )
    }

    func categoryEditTransaction() -> DatabaseTransactionExecutor<
        Category.Edit.Scope
    > {
        DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Category.Edit.Scope(
                    category: Category.Repository.Database(context: context),
                    metadata: WebModule.Metadata.Repository.Database(
                        context: context
                    )
                )
            }
        )
    }

    func categoryRemoveTransaction() -> DatabaseTransactionExecutor<
        Category.Remove.Scope
    > {
        DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Category.Remove.Scope(
                    article: Article.Repository.Database(context: context),
                    category: Category.Repository.Database(context: context),
                    metadata: WebModule.Metadata.Repository.Database(
                        context: context
                    )
                )
            }
        )
    }
}
