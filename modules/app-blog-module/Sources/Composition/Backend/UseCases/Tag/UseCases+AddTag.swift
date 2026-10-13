public import BlogApplication
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

    public func makeAddTag() -> AddTag {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteTagMetadata(
                    tag: TagDatabaseRepository(
                        context: context
                    ),
                    metadata: MetadataDatabaseRepository(
                        context: context
                    ),
                    variable: VariableDatabaseQueries(
                        context: .init(connection: context.connection)
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
