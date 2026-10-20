public import AuthApplication
import FeatherInfrastructure
import UserApplication
import UserInfrastructure

extension UseCases {

    public func makeGetCurrentUser() -> AuthApplication.GetCurrentUser {
        let query = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Identity.Query.Scope(
                    identity: Identity.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(query: query)
    }
}
