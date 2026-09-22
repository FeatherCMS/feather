import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeRemoveSession() -> RemoveSession {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteSession(
                    session: SessionDatabaseRepository(context: context)
                )
            }
        )
        return RemoveSession(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
