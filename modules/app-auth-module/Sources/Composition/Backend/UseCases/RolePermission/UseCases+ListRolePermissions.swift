import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure
import UserInfrastructure
import UserModule

extension UseCases {

    func makeListRolePermissions() -> RolePermission.Search.UseCase {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                RolePermission.Search.Scope(
                    authorization: AuthModule.Authorization.Query.Database(
                        context: context
                    ),
                    rolePermissions: RolePermission.Search.Query.Database(
                        context: context
                    )
                )
            }
        )
        return RolePermission.Search.UseCase(
            authorizer: authorizer,
            query: query
        )
    }
}
