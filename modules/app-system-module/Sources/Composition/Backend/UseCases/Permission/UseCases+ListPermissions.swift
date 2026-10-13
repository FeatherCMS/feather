import FeatherInfrastructure
import SystemApplication
import SystemInfrastructure

extension UseCases {

    func makeListPermissions() -> ListPermissions {
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
