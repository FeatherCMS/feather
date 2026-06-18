import Application
import WebInfrastructure
import Infrastructure
import BlogApplication
import BlogInfrastructure
import SystemInfrastructure

struct BlogModule: Sendable {

    private let infrastructure: AppInfrastructure
    private let authorizer: any Authorizer

    init(
        infrastructure: AppInfrastructure,
        authorizer: any Authorizer
    ) {
        self.infrastructure = infrastructure
        self.authorizer = authorizer
    }
}

extension BlogModule {

    func makeListPublicPosts() -> ListPublicPosts {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadPublicBlogPost(
                    post: DatabasePostQueries(connection: connection),
                    author: DatabaseAuthorQueries(connection: connection),
                    tag: DatabaseTagQueries(connection: connection),
                    metadata: DatabaseMetadataQueries(connection: connection)
                )
            }
        )
        return .init(query: query)
    }

    func makeGetPublicPost() -> GetPublicPost {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadPublicBlogPost(
                    post: DatabasePostQueries(connection: connection),
                    author: DatabaseAuthorQueries(connection: connection),
                    tag: DatabaseTagQueries(connection: connection),
                    metadata: DatabaseMetadataQueries(connection: connection)
                )
            }
        )
        return .init(query: query)
    }

    func makeListPublicAuthors() -> ListPublicAuthors {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadPublicBlogAuthor(
                    author: DatabaseAuthorQueries(connection: connection),
                    post: DatabasePostQueries(connection: connection),
                    authorLink: DatabaseAuthorLinkQueries(
                        connection: connection
                    ),
                    metadata: DatabaseMetadataQueries(connection: connection)
                )
            }
        )
        return .init(query: query)
    }

    func makeGetPublicAuthor() -> GetPublicAuthor {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadPublicBlogAuthor(
                    author: DatabaseAuthorQueries(connection: connection),
                    post: DatabasePostQueries(connection: connection),
                    authorLink: DatabaseAuthorLinkQueries(
                        connection: connection
                    ),
                    metadata: DatabaseMetadataQueries(connection: connection)
                )
            }
        )
        return .init(query: query)
    }

    func makeListPublicTags() -> ListPublicTags {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadPublicBlogTag(
                    tag: DatabaseTagQueries(connection: connection),
                    post: DatabasePostQueries(connection: connection),
                    metadata: DatabaseMetadataQueries(connection: connection)
                )
            }
        )
        return .init(query: query)
    }

    func makeGetPublicTag() -> GetPublicTag {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadPublicBlogTag(
                    tag: DatabaseTagQueries(connection: connection),
                    post: DatabasePostQueries(connection: connection),
                    metadata: DatabaseMetadataQueries(connection: connection)
                )
            }
        )
        return .init(query: query)
    }

    func makeAddPost() -> AddPost {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WritePostMetadata(
                    post: DatabasePostRepository(connection: connection),
                    metadata: DatabaseMetadataRepository(
                        connection: connection
                    ),
                    variable: DatabaseVariableQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: infrastructure.idGenerator
        )
    }

    func makeGetPost() -> GetPost {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadPostMetadata(
                    post: DatabasePostQueries(connection: connection),
                    metadata: DatabaseMetadataQueries(connection: connection)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    func makeEditPost() -> EditPost {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WritePostMetadata(
                    post: DatabasePostRepository(connection: connection),
                    metadata: DatabaseMetadataRepository(
                        connection: connection
                    ),
                    variable: DatabaseVariableQueries(connection: connection)
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }

    func makeListPosts() -> ListPosts {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadPostMetadata(
                    post: DatabasePostQueries(connection: connection),
                    metadata: DatabaseMetadataQueries(connection: connection)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    func makeRemovePost() -> RemovePost {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WritePostMetadata(
                    post: DatabasePostRepository(connection: connection),
                    metadata: DatabaseMetadataRepository(
                        connection: connection
                    ),
                    variable: DatabaseVariableQueries(connection: connection)
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }

    func makeAddAuthor() -> AddAuthor {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteAuthorMetadata(
                    author: DatabaseAuthorRepository(connection: connection),
                    metadata: DatabaseMetadataRepository(
                        connection: connection
                    ),
                    variable: DatabaseVariableQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: infrastructure.idGenerator
        )
    }

    func makeGetAuthor() -> GetAuthor {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadAuthorMetadata(
                    author: DatabaseAuthorQueries(connection: connection),
                    metadata: DatabaseMetadataQueries(connection: connection)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    func makeEditAuthor() -> EditAuthor {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteAuthorMetadata(
                    author: DatabaseAuthorRepository(connection: connection),
                    metadata: DatabaseMetadataRepository(
                        connection: connection
                    ),
                    variable: DatabaseVariableQueries(connection: connection)
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }

    func makeListAuthors() -> ListAuthors {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadAuthorMetadata(
                    author: DatabaseAuthorQueries(connection: connection),
                    metadata: DatabaseMetadataQueries(connection: connection)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    func makeRemoveAuthor() -> RemoveAuthor {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteAuthorPostsMetadata(
                    post: DatabasePostRepository(connection: connection),
                    author: DatabaseAuthorRepository(connection: connection),
                    metadata: DatabaseMetadataRepository(connection: connection)
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }

    func makeAddAuthorLink() -> AddAuthorLink {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteAuthorLink(
                    authorLink: DatabaseAuthorLinkRepository(
                        connection: connection
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: infrastructure.idGenerator
        )
    }

    func makeGetAuthorLink() -> GetAuthorLink {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadAuthorLink(
                    authorLink: DatabaseAuthorLinkQueries(
                        connection: connection
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    func makeEditAuthorLink() -> EditAuthorLink {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteAuthorLink(
                    authorLink: DatabaseAuthorLinkRepository(
                        connection: connection
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }

    func makeListAuthorLinks() -> ListAuthorLinks {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadAuthorLink(
                    authorLink: DatabaseAuthorLinkQueries(
                        connection: connection
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    func makeRemoveAuthorLink() -> RemoveAuthorLink {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteAuthorLink(
                    authorLink: DatabaseAuthorLinkRepository(
                        connection: connection
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }

    func makeAddTag() -> AddTag {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteTagMetadata(
                    tag: DatabaseTagRepository(connection: connection),
                    metadata: DatabaseMetadataRepository(
                        connection: connection
                    ),
                    variable: DatabaseVariableQueries(connection: connection)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: infrastructure.idGenerator
        )
    }

    func makeGetTag() -> GetTag {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadTagMetadata(
                    tag: DatabaseTagQueries(connection: connection),
                    metadata: DatabaseMetadataQueries(connection: connection)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    func makeEditTag() -> EditTag {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteTagMetadata(
                    tag: DatabaseTagRepository(connection: connection),
                    metadata: DatabaseMetadataRepository(
                        connection: connection
                    ),
                    variable: DatabaseVariableQueries(connection: connection)
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }

    func makeListTags() -> ListTags {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadTagMetadata(
                    tag: DatabaseTagQueries(connection: connection),
                    metadata: DatabaseMetadataQueries(connection: connection)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    func makeRemoveTag() -> RemoveTag {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteTagPostsMetadata(
                    post: DatabasePostRepository(connection: connection),
                    tag: DatabaseTagRepository(connection: connection),
                    metadata: DatabaseMetadataRepository(connection: connection)
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }

    func makeGetSettings() -> GetSettings {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { connection in
                ReadSettings(
                    settings: DatabaseSettingsQueries(connection: connection)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    func makeEditSettings() -> EditSettings {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteSettings(
                    settings: DatabaseSettingsRepository(connection: connection)
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
