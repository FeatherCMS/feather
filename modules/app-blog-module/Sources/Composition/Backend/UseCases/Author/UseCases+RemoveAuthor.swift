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

    public func makeRemoveAuthor() -> RemoveAuthor {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteAuthorPostsMetadata(
                    post: PostDatabaseRepository(
                        context: .init(
                            connection: context.connection,
                            idGenerator: idGenerator
                        )
                    ),
                    author: AuthorDatabaseRepository(
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
