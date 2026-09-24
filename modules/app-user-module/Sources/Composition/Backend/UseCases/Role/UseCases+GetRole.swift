import FeatherInfrastructure
import UserApplication
import UserInfrastructure

extension UseCases {

    func makeGetRole() -> GetRole {
        let query = DatabaseQueryExecutor(
            database: database,
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
