import AuthAdminAPI
import AuthAppAPI
import AuthApplication
import AuthInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemApplication
import UserApplication
import UserBackend
import UserInfrastructure

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
