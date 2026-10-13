import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeAddCredential() -> AddCredential {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteCredentialLink(
                    credential: CredentialDatabaseRepository(context: context),
                    authEmail: AuthEmailDatabaseRepository(context: context)
                )
            }
        )
        return AddCredential(
            authorizer: authorizer,
            transaction: transaction,
            passwordHasher: BCryptPasswordHasher()
        )
    }
}
