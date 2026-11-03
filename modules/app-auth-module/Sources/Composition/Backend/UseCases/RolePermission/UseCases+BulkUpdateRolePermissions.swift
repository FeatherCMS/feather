import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {
    func makeBulkUpdateRolePermissions() -> RolePermission.BulkUpdate.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                RolePermission.BulkUpdate.Scope(
                    rolePermissions: RolePermission.Repository.Database(
                        context: context
                    )
                )
            }
        )

        return RolePermission.BulkUpdate.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
