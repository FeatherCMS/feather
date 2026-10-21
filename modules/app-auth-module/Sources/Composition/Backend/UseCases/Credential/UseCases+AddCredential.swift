import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {

    func makeAddCredential() -> Credential.Add.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Credential.Add.Scope(
                    credential: Credential.Repository.Database(
                        context: context
                    ),
                    authEmail: AuthEmail.Repository.Database(context: context)
                )
            }
        )
        return Credential.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction,
            passwordHasher: BCryptPasswordHasher()
        )
    }
}
