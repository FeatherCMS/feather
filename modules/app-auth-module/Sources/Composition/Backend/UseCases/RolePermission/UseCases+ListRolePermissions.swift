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
                    authorization: Identity.Authorization.Query.Database(
                        connection: context.connection
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
