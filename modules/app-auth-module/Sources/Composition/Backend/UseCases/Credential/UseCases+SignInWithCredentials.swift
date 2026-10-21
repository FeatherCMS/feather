import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure
import UserInfrastructure
import UserModule

extension UseCases {

    func makeSignInWithCredentials() -> SignInWithCredentials {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteAuth(
                    identity: Identity.Repository.Database(context: context),
                    credential: CredentialDatabaseRepository(context: context),
                    authEmail: AuthEmailDatabaseRepository(
                        context: context
                    ),
                    session: SessionDatabaseRepository(context: context),
                    magicLink: MagicLinkDatabaseRepository(context: context)
                )
            }
        )
        return SignInWithCredentials(
            transaction: transaction,
            passwordHasher: BCryptPasswordHasher()
        )
    }
}
