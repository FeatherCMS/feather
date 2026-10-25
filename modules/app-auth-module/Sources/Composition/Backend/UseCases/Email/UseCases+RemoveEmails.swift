import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherApplication
import FeatherInfrastructure

extension UseCases {
    func makeRemoveEmails() -> Email.Remove.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext
            ) { context in
                Email.Remove.Scope(
                    authEmail: Email.Repository.Database(context: context)
                )
            }
        )
    }
}
