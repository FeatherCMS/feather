import FeatherInfrastructure
import UserApplication
import UserInfrastructure

extension UseCases {

    func makeRemoveRole() -> RemoveRole {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
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
