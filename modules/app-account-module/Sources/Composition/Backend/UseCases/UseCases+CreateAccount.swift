import AccountApplication
import AccountInfrastructure
import AuthInfrastructure
import FeatherInfrastructure
import UserInfrastructure

extension UseCases {

    func makeCreateAccount() -> AccountApplication.CreateAccount {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteAccount(
                    identity: IdentityDatabaseRepository(context: context),
                    authEmail: AuthEmailDatabaseRepository(context: context),
                    credential: CredentialDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            passwordHasher: BCryptPasswordHasher(),
            events: events
        )
    }
}
