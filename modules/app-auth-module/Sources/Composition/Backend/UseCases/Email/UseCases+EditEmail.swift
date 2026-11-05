import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherApplication
import FeatherInfrastructure

extension UseCases {
    func makeEditEmail() -> Email.Edit.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext
            ) { context in
                Email.Edit.Scope(
                    authEmail: Email.Repository.Database(context: context)
                )
            }
        )
    }
}
