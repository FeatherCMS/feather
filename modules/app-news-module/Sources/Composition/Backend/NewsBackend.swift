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

public struct NewsBackend: Sendable {
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

extension NewsBackend {
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

    public func makeGetPublicArticle() -> GetPublicArticle {
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

    public func makeListPublicCategories() -> ListPublicCategories {
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

    public func makeAddArticle() -> AddArticle {
        .init(
            authorizer: authorizer,
            transaction: articleTransaction()
        )
    }

    public func makeGetArticle() -> GetArticle {
        .init(authorizer: authorizer, query: articleQuery())
    }

    public func makeEditArticle() -> EditArticle {
        .init(authorizer: authorizer, transaction: articleTransaction())
    }

    public func makeListArticles() -> ListArticles {
        .init(authorizer: authorizer, query: articleQuery())
    }

    public func makeRemoveArticle() -> RemoveArticle {
        .init(authorizer: authorizer, transaction: articleTransaction())
    }

    public func makeAddCategory() -> AddCategory {
        .init(
            authorizer: authorizer,
            transaction: categoryTransaction()
        )
    }

    public func makeGetCategory() -> GetCategory {
        .init(authorizer: authorizer, query: categoryQuery())
    }

    public func makeEditCategory() -> EditCategory {
        .init(authorizer: authorizer, transaction: categoryTransaction())
    }

    public func makeListCategories() -> ListCategories {
        .init(authorizer: authorizer, query: categoryQuery())
    }

    public func makeRemoveCategory() -> RemoveCategory {
        .init(
            authorizer: authorizer,
            transaction: categoryArticlesTransaction()
        )
    }

}

extension NewsBackend {
    fileprivate func articleQuery() -> DatabaseQueryExecutor<
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

    fileprivate func articleTransaction() -> DatabaseTransactionExecutor<
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

    fileprivate func categoryQuery() -> DatabaseQueryExecutor<
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

    fileprivate func categoryTransaction() -> DatabaseTransactionExecutor<
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

    fileprivate func categoryArticlesTransaction()
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
