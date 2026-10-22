public import AuthApplication
import AuthInfrastructure
public import AuthModule
import FeatherInfrastructure
import UserInfrastructure
import UserModule

extension UseCases {

    public func makeTokenAuth() -> AuthModule.Auth.TokenAuth.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                AuthModule.Auth.TokenAuth.Scope(
                    identity: Identity.Repository.Database(context: context),
                    authorization: AuthModule.Authorization.Query.Database(
                        context: context
                    ),
                    session: Session.Repository.Database(context: context)
                )
            }
        )
        return AuthModule.Auth.TokenAuth.UseCase(
            transaction: transaction
        )
    }
}
