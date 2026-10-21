import FeatherInfrastructure
import UserApplication
import UserInfrastructure
import UserModule

extension UseCases {

    func makeRemoveRole() -> Role.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Role.Remove.Scope(
                    role: Role.Repository.Database(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
