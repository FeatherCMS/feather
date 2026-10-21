import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {
    func makeListAuthEmails() -> AuthEmail.List.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext
            ) { context in
                AuthEmail.List.Scope(
                    authEmail: AuthEmail.Repository.Database(context: context)
                )
            }
        )
    }

    func makeAddAuthEmail() -> AuthEmail.Add.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext
            ) { context in
                AuthEmail.Add.Scope(
                    authEmail: AuthEmail.Repository.Database(context: context)
                )
            }
        )
    }

    func makeEditAuthEmail() -> AuthEmail.Edit.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext
            ) { context in
                AuthEmail.Edit.Scope(
                    authEmail: AuthEmail.Repository.Database(context: context)
                )
            }
        )
    }

    func makeRemoveAuthEmails() -> AuthEmail.Remove.UseCase {
        .init(
            authorizer: authorizer,
            transaction: DatabaseTransactionExecutor(
                databaseContext: databaseContext
            ) { context in
                AuthEmail.Remove.Scope(
                    authEmail: AuthEmail.Repository.Database(context: context)
                )
            }
        )
    }
}
