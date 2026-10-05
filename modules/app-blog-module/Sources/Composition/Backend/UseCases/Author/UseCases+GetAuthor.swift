public import BlogApplication
import BlogInfrastructure
import FeatherInfrastructure
import WebInfrastructure

extension UseCases {

    public func makeGetAuthor() -> GetAuthor {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
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
