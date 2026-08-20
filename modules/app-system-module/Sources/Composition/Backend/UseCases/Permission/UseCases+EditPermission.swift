import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemAdminAPI
import SystemAppAPI
import SystemApplication
import SystemInfrastructure

extension UseCases {

    func makeEditPermission() -> EditPermission {
            let transaction = DatabaseTransactionExecutor(
                database: database,
                idGenerator: idGenerator,
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

