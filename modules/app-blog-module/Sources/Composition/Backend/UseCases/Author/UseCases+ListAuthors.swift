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
