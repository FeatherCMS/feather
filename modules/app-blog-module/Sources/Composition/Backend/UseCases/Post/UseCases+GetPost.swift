public import BlogApplication
import BlogInfrastructure
import FeatherInfrastructure
import WebInfrastructure

extension UseCases {

    public func makeGetPost() -> GetPost {
        let query = DatabaseQueryExecutor(
            database: database,
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
}
