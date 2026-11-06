import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {

    func makeRemoveCredential() -> Credential.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Credential.Remove.Scope(
                    credential: Credential.Repository.Database(
                        context: context
                    )
                )
            }
        )
        return Credential.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
