import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure

extension UseCases {

    func makeRemovePermission() -> RemovePermission {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WritePermission(
                    permission: PermissionDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
