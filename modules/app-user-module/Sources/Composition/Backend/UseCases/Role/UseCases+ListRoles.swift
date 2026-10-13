import FeatherInfrastructure
import UserApplication
import UserInfrastructure

extension UseCases {

    func makeListRoles() -> ListRoles {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                ReadRole(
                    role: RoleDatabaseQueries(
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
