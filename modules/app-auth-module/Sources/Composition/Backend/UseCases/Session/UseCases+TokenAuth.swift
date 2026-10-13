public import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure
import UserInfrastructure

extension UseCases {

    public func makeTokenAuth() -> TokenAuth {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteAuth(
                    identity: IdentityDatabaseRepository(context: context),
                    credential: CredentialDatabaseRepository(context: context),
                    authEmail: AuthEmailDatabaseRepository(
                        context: context
                    ),
                    session: SessionDatabaseRepository(context: context),
                    magicLink: MagicLinkDatabaseRepository(context: context)
                )
            }
        )
        return TokenAuth(
            transaction: transaction
        )
    }
}
