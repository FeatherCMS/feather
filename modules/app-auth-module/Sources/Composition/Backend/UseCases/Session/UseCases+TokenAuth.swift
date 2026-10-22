public import AuthApplication
import AuthInfrastructure
public import AuthModule
import FeatherInfrastructure
import UserInfrastructure
import UserModule

extension UseCases {

    public func makeTokenAuth() -> AuthModule.Authorization.Token.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                AuthModule.Authorization.Token.Scope(
                    identity: Identity.Repository.Database(context: context),
                    roles: AuthModule.Authorization.Database(
                        context: context
                    ),
                    permissions: AuthModule.Authorization.Database(
                        context: context
                    ),
                    session: Session.Repository.Database(context: context)
                )
            }
        )
        return AuthModule.Authorization.Token.UseCase(
            transaction: transaction
        )
    }
}
