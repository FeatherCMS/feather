public import BlogApplication
import BlogInfrastructure
import FeatherInfrastructure
import SystemInfrastructure
import WebInfrastructure

extension UseCases {

    public func makeEditPost() -> EditPost {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WritePostMetadata(
                    post: PostDatabaseRepository(
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
        return .init(authorizer: authorizer, transaction: transaction)
    }
}
