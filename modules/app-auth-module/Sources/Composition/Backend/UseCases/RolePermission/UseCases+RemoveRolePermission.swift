import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure

extension UseCases {

    func makeRemoveRolePermission() -> RolePermission.Remove.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                RolePermission.Remove.Scope(
                    rolePermissions: RolePermission.Repository.Database(
                        context: context
                    )
                )
            }
        )
        return RolePermission.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )
    }
}
