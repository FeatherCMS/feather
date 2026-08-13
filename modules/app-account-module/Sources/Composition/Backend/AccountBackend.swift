import AccountAdminAPI
import AccountAppAPI
import AccountApplication
import AccountInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import UserApplication
import UserInfrastructure

public struct AccountBackend: Sendable, AccountAdminAPI.APIProtocol,
    AccountAppAPI.APIProtocol
{
    private let database: any DatabaseClient
    private let idGenerator: any IDGenerator
    private let authorizer: any Authorizer
    private let mailSender: any MailSender
    private let events: any EventPublisher

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        authorizer: any Authorizer,
        mailSender: any MailSender,
        events: any EventPublisher
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.authorizer = authorizer
        self.mailSender = mailSender
        self.events = events
    }

    func makeCompleteInvitationRegistration()
        -> AccountApplication.CompleteInvitationRegistration
    {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteInvitation(
                    invitation: InvitationDatabaseRepository(context: context),
                    identity: IdentityDatabaseRepository(context: context),
                    role: RoleDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            transaction: transaction
        )
    }

    func makeAddInvitation() -> AddInvitation {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteInvitation(
                    invitation: InvitationDatabaseRepository(context: context),
                    identity: IdentityDatabaseRepository(context: context),
                    role: RoleDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction,
            events: events,
            mailSender: mailSender
        )
    }

    func makeGetInvitation() -> GetInvitation {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadInvitation(
                    invitation: InvitationDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    func makeEditInvitation() -> EditInvitation {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteInvitationOnly(
                    invitation: InvitationDatabaseRepository(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }

    func makeListInvitations() -> ListInvitations {
        let query = DatabaseQueryExecutor(
            database: database,
            scope: { context in
                ReadInvitation(
                    invitation: InvitationDatabaseQueries(
                        context: context
                    )
                )
            }
        )
        return .init(authorizer: authorizer, query: query)
    }

    func makeRemoveInvitation() -> RemoveInvitation {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteInvitationOnly(
                    invitation: InvitationDatabaseRepository(context: context)
                )
            }
        )
        return .init(authorizer: authorizer, transaction: transaction)
    }
}

extension AccountBackend {

    func makeEditSettings() -> AccountApplication.EditSettings {
        let transaction = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteSettings(
                    settings: SettingsDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            transaction: transaction
        )
    }

    func makeGetSettings() -> AccountApplication.GetSettings {
        let query = DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteSettings(
                    settings: SettingsDatabaseRepository(context: context)
                )
            }
        )
        return .init(
            authorizer: authorizer,
            query: query
        )
    }
}
