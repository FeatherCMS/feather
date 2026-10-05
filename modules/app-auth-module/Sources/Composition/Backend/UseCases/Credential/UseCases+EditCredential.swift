import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeEditCredential() -> EditCredential {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteCredentialLink(
                    credential: CredentialDatabaseRepository(context: context),
                    authEmail: AuthEmailDatabaseRepository(context: context)
                )
            }
        )
        return EditCredential(
            authorizer: authorizer,
            transaction: transaction,
            passwordHasher: BCryptPasswordHasher()
        )
    }
}
