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

    public func makeListPosts() -> ListPosts {
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

