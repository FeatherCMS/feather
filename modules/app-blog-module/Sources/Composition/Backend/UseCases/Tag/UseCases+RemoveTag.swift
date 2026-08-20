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

    public func makeRemoveTag() -> RemoveTag {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteTagPostsMetadata(
                    post: PostDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: idGenerator
                        )
                    ),
                    tag: TagDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: idGenerator
                        )
                    ),
                    metadata: MetadataDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: idGenerator
                        )
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
