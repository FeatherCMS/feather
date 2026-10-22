import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure
import UserInfrastructure
import UserModule

extension UseCases {

    func makeSignInWithCredentials()
        -> AuthModule.Auth.SignIn.Credentials.UseCase
    {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                AuthModule.Auth.SignIn.Credentials.Scope(
                    identity: Identity.Repository.Database(context: context),
                    authorization: AuthModule.Authorization.Query.Database(
                        context: context
                    ),
                    credential: Credential.Repository.Database(
                        context: context
                    ),
                    authEmail: Email.Repository.Database(
                        context: context
                    ),
                    session: Session.Repository.Database(context: context)
                )
            }
        )
        return AuthModule.Auth.SignIn.Credentials.UseCase(
            transaction: transaction,
            passwordHasher: BCryptPasswordHasher()
        )
    }
}
