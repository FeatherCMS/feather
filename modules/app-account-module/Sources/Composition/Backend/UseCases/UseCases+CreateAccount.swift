import AccountApplication
import AccountInfrastructure
import AuthInfrastructure
import FeatherInfrastructure
import UserInfrastructure

extension UseCases {

    func makeCreateAccount() -> AccountApplication.CreateAccount {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteAccount(
                    identity: Identity.Repository.Database(context: context),
                    authEmail: AuthEmail.Repository.Database(context: context),
                    credential: Credential.Repository.Database(context: context)
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
