import BlogApplication
import BlogInfrastructure
import FeatherInfrastructure
import WebInfrastructure

extension UseCases {

    public func makeListAuthors() -> ListAuthors {
        let query = DatabaseQueryExecutor(
            database: database,
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
}
