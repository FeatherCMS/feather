import BlogApplication
import BlogInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import MediaBackend
import SystemInfrastructure
import WebInfrastructure

public struct BlogBackend: Sendable {

    private struct RuntimeInfrastructure: Sendable {
        let database: any DatabaseClient
        let idGenerator: any IDGenerator
    }

    private let infrastructure: RuntimeInfrastructure
    private let authorizer: any Authorizer
    let media: MediaBackend

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        authorizer: any Authorizer,
        media: MediaBackend
    ) {
        self.infrastructure = .init(
            database: database,
            idGenerator: idGenerator
        )
        self.authorizer = authorizer
        self.media = media
    }
}

extension BlogBackend {

    public func makeGetPublicSettings() -> DatabaseQueryExecutor<WriteSettings>
    {
        DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { context in
                WriteSettings(
                    settings: SettingsDatabaseRepository(context: context)
                )
            }
        )
    }

    public func makeListPublicPosts() -> ListPublicPosts {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { context in
                ReadPublic(
                    post: PostDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    author: AuthorDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    tag: TagDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    authorLink: AuthorLinkDatabaseQueries(
                        context: context
                    ),
                    metadata: MetadataDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }

    public func makeGetPublicPost() -> GetPublicPost {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { context in
                ReadPublic(
                    post: PostDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    author: AuthorDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    tag: TagDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    authorLink: AuthorLinkDatabaseQueries(
                        context: context
                    ),
                    metadata: MetadataDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }

    public func makeListPublicAuthors() -> ListPublicAuthors {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { context in
                ReadPublic(
                    post: PostDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    author: AuthorDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    tag: TagDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    authorLink: AuthorLinkDatabaseQueries(
                        context: context
                    ),
                    metadata: MetadataDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }

    public func makeGetPublicAuthor() -> GetPublicAuthor {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { context in
                ReadPublic(
                    post: PostDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    author: AuthorDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    tag: TagDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    authorLink: AuthorLinkDatabaseQueries(
                        context: context
                    ),
                    metadata: MetadataDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }

    public func makeListPublicTags() -> ListPublicTags {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { context in
                ReadPublic(
                    post: PostDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    author: AuthorDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    tag: TagDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    authorLink: AuthorLinkDatabaseQueries(
                        context: context
                    ),
                    metadata: MetadataDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }

    public func makeGetPublicTag() -> GetPublicTag {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { context in
                ReadPublic(
                    post: PostDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    author: AuthorDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    tag: TagDatabaseQueries(
                        context: context,
                        metadata: MetadataDatabaseQueries(
                            context: context
                        )
                    ),
                    authorLink: AuthorLinkDatabaseQueries(
                        context: context
                    ),
                    metadata: MetadataDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }

    public func makeAddPost() -> AddPost {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            scope: { context in
                WritePostMetadata(
                    post: PostDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    ),
                    metadata: MetadataDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    ),
                    variable: VariableDatabaseQueries(
                        context: .init(connection: context.connection)
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    public func makeGetPost() -> GetPost {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { context in
                ReadPostMetadata(
                    post: PostDatabaseQueries(
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
        return .init(authorizer: authorizer, query: query)
    }

    public func makeEditPost() -> EditPost {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            scope: { context in
                WritePostMetadata(
                    post: PostDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    ),
                    metadata: MetadataDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    ),
                    variable: VariableDatabaseQueries(
                        context: .init(connection: context.connection)
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }

    public func makeListPosts() -> ListPosts {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { context in
                ReadPostMetadata(
                    post: PostDatabaseQueries(
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
        return .init(authorizer: authorizer, query: query)
    }

    public func makeRemovePost() -> RemovePost {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            scope: { context in
                WritePostMetadata(
                    post: PostDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    ),
                    metadata: MetadataDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    ),
                    variable: VariableDatabaseQueries(
                        context: .init(connection: context.connection)
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }

    public func makeAddAuthor() -> AddAuthor {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            scope: { context in
                WriteAuthorMetadata(
                    author: AuthorDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    ),
                    metadata: MetadataDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    ),
                    variable: VariableDatabaseQueries(
                        context: .init(connection: context.connection)
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    public func makeGetAuthor() -> GetAuthor {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { context in
                ReadAuthorMetadata(
                    author: AuthorDatabaseQueries(
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
        return .init(authorizer: authorizer, query: query)
    }

    public func makeEditAuthor() -> EditAuthor {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            scope: { context in
                WriteAuthorMetadata(
                    author: AuthorDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    ),
                    metadata: MetadataDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    ),
                    variable: VariableDatabaseQueries(
                        context: .init(connection: context.connection)
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }

    public func makeListAuthors() -> ListAuthors {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { context in
                ReadAuthorMetadata(
                    author: AuthorDatabaseQueries(
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
        return .init(authorizer: authorizer, query: query)
    }

    public func makeRemoveAuthor() -> RemoveAuthor {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            scope: { context in
                WriteAuthorPostsMetadata(
                    post: PostDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    ),
                    author: AuthorDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    ),
                    metadata: MetadataDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }

    public func makeAddAuthorLink() -> AddAuthorLink {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            scope: { context in
                WriteAuthorLink(
                    authorLink: AuthorLinkDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    public func makeGetAuthorLink() -> GetAuthorLink {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { context in
                ReadAuthorLink(
                    authorLink: AuthorLinkDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    public func makeEditAuthorLink() -> EditAuthorLink {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            scope: { context in
                WriteAuthorLink(
                    authorLink: AuthorLinkDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }

    public func makeListAuthorLinks() -> ListAuthorLinks {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { context in
                ReadAuthorLink(
                    authorLink: AuthorLinkDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    public func makeRemoveAuthorLink() -> RemoveAuthorLink {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            scope: { context in
                WriteAuthorLink(
                    authorLink: AuthorLinkDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }

    public func makeAddTag() -> AddTag {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            scope: { context in
                WriteTagMetadata(
                    tag: TagDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    ),
                    metadata: MetadataDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    ),
                    variable: VariableDatabaseQueries(
                        context: .init(connection: context.connection)
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    public func makeGetTag() -> GetTag {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { context in
                ReadTagMetadata(
                    tag: TagDatabaseQueries(
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
        return .init(authorizer: authorizer, query: query)
    }

    public func makeEditTag() -> EditTag {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            scope: { context in
                WriteTagMetadata(
                    tag: TagDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    ),
                    metadata: MetadataDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    ),
                    variable: VariableDatabaseQueries(
                        context: .init(connection: context.connection)
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }

    public func makeListTags() -> ListTags {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { context in
                ReadTagMetadata(
                    tag: TagDatabaseQueries(
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
        return .init(authorizer: authorizer, query: query)
    }

    public func makeRemoveTag() -> RemoveTag {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            scope: { context in
                WriteTagPostsMetadata(
                    post: PostDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    ),
                    tag: TagDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    ),
                    metadata: MetadataDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: infrastructure.idGenerator
                        )
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }

    public func makeGetSettings() -> GetSettings {
        let query = DatabaseQueryExecutor(
            database: infrastructure.database,
            scope: { context in
                WriteSettings(
                    settings: SettingsDatabaseRepository(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    public func makeEditSettings() -> EditSettings {
        let transaction = DatabaseTransactionExecutor(
            database: infrastructure.database,
            idGenerator: infrastructure.idGenerator,
            scope: { context in
                WriteSettings(
                    settings: SettingsDatabaseRepository(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
