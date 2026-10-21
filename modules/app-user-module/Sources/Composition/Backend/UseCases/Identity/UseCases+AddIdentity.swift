import FeatherInfrastructure
import UserApplication
import UserInfrastructure
import UserModule

extension UseCases {

    func makeAddIdentity() -> Identity.Add.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Identity.Add.Scope(
                    identity: Identity.Repository.Database(context: context),
                    role: Role.Repository.Database(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            events: events
        )
    }
}
