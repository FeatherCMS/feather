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

    public func makeGetTag() -> GetTag {
            let query = DatabaseQueryExecutor(
                database: database,
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
}

