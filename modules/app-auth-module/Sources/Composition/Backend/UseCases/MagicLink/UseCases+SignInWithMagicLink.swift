import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure
import UserInfrastructure
import UserModule

extension UseCases {

    func makeSignInWithMagicLink() -> AuthModule.Auth.SignIn.MagicLink.UseCase {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                AuthModule.Auth.SignIn.MagicLink.Scope(
                    identity: Identity.Repository.Database(context: context),
                    authorization: AuthModule.Authorization.Query.Database(
                        context: context
                    ),
                    authEmail: Email.Repository.Database(
                        context: context
                    ),
                    magicLink: MagicLink.Repository.Database(context: context),
                    session: Session.Repository.Database(context: context)
                )
            }
        )
        return AuthModule.Auth.SignIn.MagicLink.UseCase(
            transaction: transaction
        )
    }
}
