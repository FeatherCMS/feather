public import AuthApplication
import FeatherInfrastructure
import UserApplication
import UserInfrastructure
import UserModule

extension UseCases {

    public func makeGetCurrentUser() -> AuthApplication.GetCurrentUser {
        let detailQuery = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Identity.Detail.Scope(
                    identity: Identity.Detail.Query.Database(
                        context: context
                    )
                )
            }
        )
        let authorizationQuery = DatabaseQueryExecutor(
            databaseContext: databaseContext,
            scope: { context in
                Identity.Authorization.Query.Scope(
                    identity: Identity.Authorization.Query.Database(
                        context: context
                    )
                )
            }
        )
        return .init(
            detailQuery: detailQuery,
            authorizationQuery: authorizationQuery
        )
    }
}
