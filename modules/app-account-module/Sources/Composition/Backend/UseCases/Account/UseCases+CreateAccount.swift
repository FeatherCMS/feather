import AccountApplication
import AccountInfrastructure
import AccountModule
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure
import UserInfrastructure
import UserModule

extension UseCases {

    func makeCreateAccount() -> Account.Create.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Account.Create.Scope(
                    identity: Identity.Repository.Database(context: context),
                    authEmail: Email.Repository.Database(context: context),
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
