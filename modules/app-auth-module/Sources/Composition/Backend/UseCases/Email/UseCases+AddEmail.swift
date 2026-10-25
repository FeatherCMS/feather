import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherApplication
import FeatherInfrastructure

extension UseCases {
    func makeAddEmail() -> Email.Add.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext
            ) { context in
                Email.Add.Scope(
                    authEmail: Email.Repository.Database(context: context)
                )
            }
        )
    }
}
