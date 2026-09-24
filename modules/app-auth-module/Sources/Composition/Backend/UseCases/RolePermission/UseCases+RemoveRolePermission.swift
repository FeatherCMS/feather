import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeRemoveRolePermission() -> RemoveRolePermission {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteRolePermissions(
                    rolePermissions: RolePermissionDatabaseRepository(
                        context: context
                    )
                )
            }
        )
        return RemoveRolePermission(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
