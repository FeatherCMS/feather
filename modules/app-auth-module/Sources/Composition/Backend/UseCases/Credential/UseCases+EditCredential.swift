import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeEditCredential() -> EditCredential {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteCredentialLink(
                    credential: CredentialDatabaseRepository(context: context)
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
