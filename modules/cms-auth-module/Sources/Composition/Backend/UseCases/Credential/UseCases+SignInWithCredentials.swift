import AuthApplication
import AuthInfrastructure
import AuthModule
import FeatherInfrastructure
import UserInfrastructure
import UserModule

extension UseCases {

    func makeSignInWithCredentials()
        -> AuthModule.Authorization.SignIn.Credentials.UseCase
    {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                AuthModule.Authorization.SignIn.Credentials.Scope(
                    identity: Identity.Repository.Database(context: context),
                    roles: AuthModule.Authorization.Roles.Query.Database(
                        context: context
                    ),
                    permissions: AuthModule.Authorization.Permissions.Query
                        .Database(
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
        return AuthModule.Authorization.SignIn.Credentials.UseCase(
            transaction: transaction,
            passwordHasher: BCryptPasswordHasher()
        )
    }
}
