import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeRemoveCredential() -> RemoveCredential {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteCredentialLink(
                    credential: CredentialDatabaseRepository(context: context),
                    authEmail: AuthEmailDatabaseRepository(context: context)
                )
            }
        )
        return RemoveCredential(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
