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

    public func makeRemovePost() -> RemovePost {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WritePostMetadata(
                    post: PostDatabaseRepository(
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
                    ),
                    variable: VariableDatabaseQueries(
                        context: .init(connection: context.connection)
                    )
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
