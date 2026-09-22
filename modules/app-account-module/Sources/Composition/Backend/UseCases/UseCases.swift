import AccountApplication
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain

public struct UseCases: Sendable {
    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let authorizer: any Authorizer
    let mailSender: any MailSender
    let events: any EventPublisher
    let credentialWriter: any InvitationCredentialWriter

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
        self.credentialWriter = InvitationCredentialWriterAdapter()
    }

}
