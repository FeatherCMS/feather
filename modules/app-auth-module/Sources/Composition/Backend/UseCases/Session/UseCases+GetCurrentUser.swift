public import AuthApplication
import AuthInfrastructure
public import AuthModule
import FeatherInfrastructure
import UserApplication
import UserInfrastructure
import UserModule

extension UseCases {

    public func makeGetCurrentUser() -> AuthModule.Auth.CurrentUser.UseCase {
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
                    authorization: Identity.Authorization.Query.Database(
                        connection: context.connection
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
