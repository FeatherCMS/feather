import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeAddCredential() -> AddCredential {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteCredentialLink(
                    credential: CredentialDatabaseRepository(context: context)
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
