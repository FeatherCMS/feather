import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {

    func makeEditCredential() -> Credential.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Credential.Edit.Scope(
                    credential: Credential.Repository.Database(
                        context: context
                    ),
                    authEmail: Email.Repository.Database(context: context)
                )
            }
        )
        return Credential.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction,
            passwordHasher: BCryptPasswordHasher()
        )
    }
}
