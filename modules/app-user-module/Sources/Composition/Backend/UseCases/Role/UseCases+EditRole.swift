import FeatherInfrastructure
import UserApplication
import UserInfrastructure
import UserModule

extension UseCases {

    func makeEditRole() -> Role.Edit.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Role.Edit.Scope(
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
