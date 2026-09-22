import AuthApplication
import FeatherInfrastructure
import UserApplication
import UserInfrastructure

extension UseCases {

    public func makeGetCurrentUser() -> AuthApplication.GetCurrentUser {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadIdentity(
                    identity: IdentityDatabaseQueries(
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
