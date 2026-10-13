import FeatherInfrastructure
import UserApplication
import UserInfrastructure

extension UseCases {

    func makeAddRole() -> AddRole {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteRole(
                    role: RoleDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
