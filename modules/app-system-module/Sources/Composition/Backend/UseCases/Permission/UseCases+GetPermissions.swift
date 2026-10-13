import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure

extension UseCases {

    func makeGetPermissions() -> GetPermission {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
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
