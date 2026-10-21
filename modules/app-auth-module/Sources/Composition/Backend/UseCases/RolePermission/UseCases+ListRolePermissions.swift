import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure
import UserInfrastructure
import UserModule

extension UseCases {

    func makeListRolePermissions() -> ListRolePermissions {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                AuthScope(
                    authorization: Identity.Authorization.Query.Database(
                        connection: context.connection
                    ),
                    rolePermissions: RolePermissionDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return ListRolePermissions(authorizer: authorizer, query: query)
    }
}
