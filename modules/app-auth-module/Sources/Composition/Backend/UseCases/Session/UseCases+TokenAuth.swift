public import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure
import UserInfrastructure
import UserModule

extension UseCases {

    public func makeTokenAuth() -> TokenAuth {
        let transaction = DatabaseTransactionExecutor(
            databaseContext: databaseContext,
            scope: { context in
                WriteAuth(
                    identity: Identity.Repository.Database(context: context),
                    authorization: Identity.Authorization.Query.Database(
                        connection: context.connection
                    ),
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
