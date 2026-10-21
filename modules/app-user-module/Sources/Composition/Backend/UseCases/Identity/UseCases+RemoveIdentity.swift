import FeatherInfrastructure
import UserApplication
import UserInfrastructure
import UserModule

extension UseCases {

    func makeRemoveIdentity() -> Identity.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Identity.Remove.Scope(
                    identity: Identity.Repository.Database(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
