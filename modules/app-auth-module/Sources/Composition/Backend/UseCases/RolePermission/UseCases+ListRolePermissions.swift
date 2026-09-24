import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure
import UserInfrastructure

extension UseCases {

    func makeListRolePermissions() -> ListRolePermissions {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                AuthScope(
                    identity: IdentityDatabaseQueries(
                        context: context
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
