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
