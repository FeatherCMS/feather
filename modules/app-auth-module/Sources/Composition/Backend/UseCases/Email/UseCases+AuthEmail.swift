import AuthApplication
import AuthInfrastructure
import FeatherInfrastructure
import FeatherModuleKit
import UserInfrastructure
import UserModule

extension UseCases {
    private func authEmailTransaction() -> any TransactionExecutor<
        WriteAuth
    > {
        DatabaseTransactionExecutor(
            databaseContext: databaseContext,
        ) { context in
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
    }

    func makeListAuthEmails() -> ListAuthEmails {
        .init(authorizer: authorizer, transaction: authEmailTransaction())
    }
    func makeAddAuthEmail() -> AddAuthEmail {
        .init(authorizer: authorizer, transaction: authEmailTransaction())
    }
    func makeEditAuthEmail() -> EditAuthEmail {
        .init(authorizer: authorizer, transaction: authEmailTransaction())
    }
    func makeRemoveAuthEmails() -> RemoveAuthEmails {
        .init(authorizer: authorizer, transaction: authEmailTransaction())
    }
}
