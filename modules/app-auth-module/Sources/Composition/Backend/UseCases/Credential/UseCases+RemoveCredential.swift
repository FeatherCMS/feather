import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeRemoveCredential() -> RemoveCredential {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteCredentialLink(
                    credential: CredentialDatabaseRepository(context: context)
                )
            }
        )
        return RemoveCredential(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
