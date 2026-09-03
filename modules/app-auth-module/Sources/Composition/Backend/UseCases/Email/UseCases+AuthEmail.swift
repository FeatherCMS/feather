import AuthApplication
import AuthInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherInfrastructure
import UserApplication
import UserBackend
import UserInfrastructure

extension UseCases {
    private func authEmailTransaction() -> any TransactionExecutor<
        WriteAuth
    > {
        DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator
        ) { context in
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
