import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {

    func makeAddRolePermission() -> RolePermission.Add.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                RolePermission.Add.Scope(
                    rolePermissions: RolePermission.Repository.Database(
                        context: context
                    )
                )
            }
        )
        return RolePermission.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
