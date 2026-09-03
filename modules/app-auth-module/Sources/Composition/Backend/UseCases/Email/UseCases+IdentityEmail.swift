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
    private func identityEmailTransaction() -> any TransactionExecutor<
        WriteAuth
    > {
        DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator
        ) { context in
            WriteAuth(
                identity: IdentityDatabaseRepository(context: context),
                credential: CredentialDatabaseRepository(context: context),
                identityEmail: IdentityEmailDatabaseRepository(
                    context: context
                ),
                session: SessionDatabaseRepository(context: context),
                magicLink: MagicLinkDatabaseRepository(context: context)
            )
        }
    }

    func makeListIdentityEmails() -> ListIdentityEmails {
        .init(authorizer: authorizer, transaction: identityEmailTransaction())
    }
    func makeAddIdentityEmail() -> AddIdentityEmail {
        .init(authorizer: authorizer, transaction: identityEmailTransaction())
    }
    func makeEditIdentityEmail() -> EditIdentityEmail {
        .init(authorizer: authorizer, transaction: identityEmailTransaction())
    }
    func makeRemoveIdentityEmails() -> RemoveIdentityEmails {
        .init(authorizer: authorizer, transaction: identityEmailTransaction())
    }
}
