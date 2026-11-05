import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {

    func makeRemoveSession() -> Session.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Session.Remove.Scope(
                    session: Session.Repository.Database(context: context)
                )
            }
        )
        return Session.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
