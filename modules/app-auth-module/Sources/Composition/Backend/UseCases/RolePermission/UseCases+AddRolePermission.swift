import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure

extension UseCases {

    func makeAddRolePermission() -> AddRolePermission {
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
        return AddRolePermission(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
