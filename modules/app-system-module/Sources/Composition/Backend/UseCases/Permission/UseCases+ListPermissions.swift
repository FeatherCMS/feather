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

    func makeListPermissions() -> ListPermissions {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadPermission(
                    permission: PermissionDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }
}
