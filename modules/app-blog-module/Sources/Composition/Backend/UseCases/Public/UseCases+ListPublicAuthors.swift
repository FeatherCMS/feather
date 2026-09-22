import BlogApplication
import BlogInfrastructure
import FeatherInfrastructure
import WebInfrastructure

extension UseCases {

    public func makeListPublicAuthors() -> ListPublicAuthors {
        let query = DatabaseQueryExecutor(
            database: database,
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
}
