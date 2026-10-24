public import AuthApplication
import AuthInfrastructure
public import AuthModule
import FeatherInfrastructure
import UserApplication
import UserInfrastructure
import UserModule

extension UseCases {

    public func makeGetCurrentUser()
        -> AuthModule.Authorization.CurrentUser.UseCase
    {
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
                AuthModule.Authorization.CurrentUser.Scope(
                    roles: AuthModule.Authorization.Roles.Query.Database(
                        context: context
                    ),
                    permissions: AuthModule.Authorization.Permissions.Query
                        .Database(
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
